class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def self.find_in_tmdb search_term
  
    movie_arr=Array.new
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    @tmdb_movies = Tmdb::Movie.find(search_term)
    @tmdb_movies.each do |tmdb_movies|
      movie_arr << {:tmdb_id => tmdb_movies.id, :title=> tmdb_movies.title, :rating =>'PG', :release_date=>tmdb_movies.release_date}
      #puts movie_arr
    end
    return movie_arr
  end
  
  def self.create_from_tmdb tmdb_id
    puts tmdb_id
    details=Tmdb::Movie.detail(tmdb_id)
    puts "\n\nDETAILS:\n\n"
    #puts details.to_s
    #:title, :rating, :description, :release_date
    #puts details["title"].to_s
    if(!details["adult"])
      rating="PG"
    else
      rating= "R"
    end
    #puts details["overview"].to_s
    #puts details["release_date"].to_s
    @movie={:title=>details["title"], :rating=>rating, :release_date=>details["release_date"]}
    puts @movie.to_s
    create!(@movie)
    return details["title"]
  end
end
