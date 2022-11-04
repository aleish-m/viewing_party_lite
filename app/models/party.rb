class Party < ApplicationRecord
  has_many :user_parties
  has_many :users, through: :user_parties
  validates_presence_of :duration, :movie_runtime, :movie_id, :host_id, :start_time, :date
  validates_numericality_of :duration, :movie_runtime, :movie_id, :host_id
  validate :compare_duration_to_movie_time

  def start_date
    date.strftime('%B %d, %Y')
  end

  def time
    start_time.strftime('%I:%M %p')
  end

  def find_host
    User.find(host_id).name
  end

  def find_title
    MovieFacade.movie_data(movie_id).title
  end

  def find_image_url
    MovieFacade.movie_data(movie_id).image
  end

  private

  def compare_duration_to_movie_time
    errors.add(:duration, "cannot be less then movie length #{movie_runtime}") if duration.to_i < movie_runtime.to_i
  end
end
