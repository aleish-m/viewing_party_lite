class MoviesController < ApplicationController

  def show
    @movie = MovieFacade.movie_data(params[:id])
    @cast = MovieFacade.cast_data(params[:id])
    @reviews = MovieFacade.review_data(params[:id])
  end

  def index
    if !params[:q].nil?
      @movies = MovieFacade.movies_search(params[:q])
      @page_title = "Movie results for: #{params[:q]}"
    elsif 
      @movies = MovieFacade.top_rated
      @page_title = 'Top Rated Movies'
    end
  end
end
