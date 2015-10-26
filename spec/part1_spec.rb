require 'spec_helper'
require 'rails_helper'

describe MoviesController, type: :controller do
    describe 'searching TMDb' do
        before (:each) do
            @fake_results=[double(:title=>"movie_title", :rating=>"movie_rating", :release_date=>"release_date"), double(:title=>"movie_title", :rating=>"movie_rating", :release_date=>"release_date")]
            @movie=double(Movie)
        end
        it 'should call the model method that performs the TMDb search' do
            #fake_results=[double(:title=>"Ted"), double(:movie2=>"movie2")]
            expect(Movie).to receive(:find_in_tmdb).with('Ted').
                and_return(@fake_results)
            post :search_tmdb, {:search_terms=>'Ted'}
        end
        it 'should redirect to movies if textbox was empty'do
            post :search_tmdb, {:search_terms=>''}
            expect(response).to redirect_to('/movies')
            expect(flash[:notice]).to eq "Invalid Search Term"
        end
        it 'should redirect to movies if search term was nil' do
            post :search_tmdb, {:search_terms=>nil}
            expect(response).to redirect_to('/movies')
            expect(flash[:notice]).to eq "Invalid Search Term"
        end
        it 'should redirect to movies if movie was not found' do
            allow(Movie).to receive(:find_in_tmdb).and_return([])
            post :search_tmdb, {:search_terms=>"Ted"}
            expect(response).to redirect_to('/movies')
            expect(flash[:notice]).to eq "No matching movies were found on TMDb"
        end
        it 'should select the Search Result template for rendering' do
            allow(@movie).to receive(:find_in_tmdb)
            post :search_tmdb, {:search_terms=>'Ted'}
            expect(response).to render_template('search_tmdb')
        end
        it 'should make the TMDb search results available to that template' do
            #fake_results=[double(:Movie=>"Movie"), double(:Movie=>"Movie")]
            allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
            post :search_tmdb, {:search_terms => 'hardware'}
            expect(assigns(:search_term)).to eq 'hardware'
            expect(assigns(:tmdb_movies)).to eq @fake_results
        end

    end
end

describe Movie do
    before (:each) do
        @fake_results=[double(:title=>"movie_title", :rating=>"movie_rating", :release_date=>"release_date"), double(:title=>"movie_title", :rating=>"movie_rating", :release_date=>"release_date")]
        @movie=double(Movie)
    end
    describe 'searching Tmdb by keyword' do
        context 'with valid API key' do
            it 'should call Tmdb with search term' do
                expect(Tmdb::Movie).to receive(:find).with('Ted')
                Movie.find_in_tmdb("Ted")
            end
            it 'returns empty array if Tmdb::Movie does not return any results' do
                result=Movie.find_in_tmdb("afdas")
                expect(result).to eq([])
            end
        end
        context 'with invalid key' do
            it'should raise InvalidKeyError if key is missing or invalid' do
                allow(Tmdb::Movie).to receive(:find).and_raise(NoMethodError)
                allow(Tmdb::Api).to receive(:response).and_return({'code'=>'401'})
                expect{Movie.find_in_tmdb('Inception')}.to raise_error(Movie::InvalidKeyError)
            end
        end
    end
end

