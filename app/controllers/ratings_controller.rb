class RatingsController < ApplicationController
  resource_description do
    short "Endpoints for methods related to a location's ratings"
  end
  before_action :authenticate_user!
  before_action :find_location
  before_action :find_rating, only: %i[show update destroy]

  def_param_group :rating do
    property :id, :number, desc: 'ID'
    property :grade, :decimal, desc: 'Grade'
    property :comment, String, desc: 'Comment in rating'
  end

  api :GET, 'locations/:location_id/ratings', 'List all ratings of a given location'
  returns array_of: :rating, code: 200, desc: 'All ratings of a given location'
  def index
    @ratings = @location.ratings
    render json: @ratings
  end

  api :POST, 'locations/:location_id/ratings', 'Create a rating for a given location'
  param_group :rating
  returns :rating, code: 200, desc: "Rating's info"
  param :rating, Hash do
    param :grade, :number, desc: 'Grade from 0 to 5', required: true
    param :comment, String, desc: 'Comment', required: true
  end
  def create
    @rating = Rating.new(rating_params)
    @rating.user = current_user
    @rating.location = @location

    if @rating.valid?
      @rating.save
      render json: @rating
    else
      render json: @rating.errors
    end
  end

  api :GET, 'locations/:location_id/ratings/:id', 'show info on a specific rating'
  returns :rating, code: 200, desc: "Rating's info"
  def show
    render json: @rating
  end

  api :PATCH, 'locations/:location_id/ratings/:id', 'update a rating'
  param :rating, Hash do
    param :grade, :number, desc: 'Grade from 0 to 5', required: true
    param :comment, String, desc: 'Comment', required: true
  end
  returns :rating, code: 200, desc: "Rating's info"
  def update
    if @rating.user == current_user
      if @rating.update(rating_params)
        render json: @rating
      else
        render json: @rating.errors
      end
    else
      render status: :unauthorized, json: { error: I18n.t('errors.unautorized') }
    end
  end

  api :DELETE, 'locations/:location_id/ratings/:id', "delete's a rating"
  def destroy
    @rating.destroy!
    render json: I18n.t('ratings.removal.success')
  rescue StandardError => e
    render json: e.message
  end

  private

  def find_location
    @location = Location.where(id: params[:location_id]).first
  end

  def find_rating
    @rating = @location.ratings.where(id: params[:id]).first
  end

  def rating_parrams
    params.require(:rating).permit(:grade, :comment)
  end
end
