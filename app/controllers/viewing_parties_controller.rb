class ViewingPartiesController < ApplicationController
  before_action :require_user

  def new
    @movie = MovieFacade.movie_data(params[:movie_id])
    @party = Party.new
    @users = User.all.where.not(id: @current_user.id)
  end

  def create
    movie = MovieFacade.movie_data(params[:movie_id])
    party = Party.new(party_params)
    guests = User.all.where.not(id: @current_user.id)

    if party.save
      party.users << @current_user
      guests.each do |guest|
        unless friend_params[:"#{guest.name}"].blank?
          party.users << guest
        end
      end
      redirect_to dashboard_path
    else
      flash.alert = party.errors.full_messages.to_sentence
      redirect_to new_movie_viewing_party_path(movie.id)
    end
  end

  private

  def friend_params
    friends_names = User.all.filter_map { |friend| friend.name if friend.id != params[:host_id].to_i }
    params.permit(friends_names)
  end

  def party_params
    params.permit(:movie_id, :duration, :date, :start_time, :host_id, :movie_runtime)
  end
end
