class MovieFacade
  def self.movie_data(movie_id)
    movie_data = MovieService.get_movie_data(movie_id)
    MovieInfo.new(movie_data)
  end

  def self.cast_data(movie_id)
    cast_data = MovieService.get_cast_data(movie_id)
    cast_data[:cast][0..9].map do |cast_member|
      Cast.new(cast_member)
    end
  end

  def self.review_data(movie_id)
    review_data = MovieService.get_review_data(movie_id)
    review_data[:results].map do |review|
      Reviews.new(review)
    end
  end

  def self.top_rated
    MovieService.get_top_rated[:results].map do |data|
      TopMovie.new(data)
    end
  end

  def self.movies_search(keyword)
    search_results = MovieService.get_movies_search(keyword)
    search_results[:results].map do |data|
      TopMovie.new(data)
    end
  end
end
