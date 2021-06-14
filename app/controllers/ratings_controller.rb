class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_location
  before_action :find_rating, only: %i[show update destroy]

  def index
    @ratings = @location.ratings
    render json: @ratings
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

  def show
    render json: @rating
  end

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
    params.require(:ratings).permit(:grade, :comment)
  end
end
