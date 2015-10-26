require 'spec_helper'
require 'rails_helper'
=begin
describe MoviesController do
    describe 'searching TMDb' do
        it 'should call the model method that performs TMDb search' do
            fake_results
            
=end

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

=begin
describe Movie do
    describe 'searching Tmdb by keyword' do
        context 'with valid API key' do
            it 'should call Tmdb with search term' do
                Tmdb::Movie.expect(:find).with('Inception')
                Movie.find_in_tmdb('Inception')
            end
        end
    end
=end

