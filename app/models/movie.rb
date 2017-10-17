class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
  
  def self.find_in_tmdb(string)
    begin
      movies = Array.new
      results = Tmdb::Movie.find(string)
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
    
    results.each do |movie|
      @ratingInfo = Tmdb::Movie.releases(movie.id)["countries"]
      @theRating = String.new
      @ratingInfo.each do |countryRating|
        if countryRating["iso_3166_1"].upcase == 'US'
          @theRating = countryRating['certification']
          if @theRating.empty?
            @theRating = "R"
          end
        end
      end
      hash = {}
      hash[:tmdb_id] = movie.id
      hash[:title] = movie.title
      hash[:rating] = @theRating
      hash[:release_date] = movie.release_date
      movies << hash
    end
    return movies
  end
  
  def self.create_from_tmdb(ids)
    ids.each do |id|
      movie = Tmdb::Movie.detail(id.to_i)
      hash = {}
      hash[:title] = movie['title']
      hash[:release_date] = movie['release_date']
      self.create!(hash)
    end
  end
  
end
