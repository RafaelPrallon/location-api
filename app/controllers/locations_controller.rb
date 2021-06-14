class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_location, only: %i[show update destroy]
  respond_to :json

  def index
    @locations = Location.all
    render json: @locations
  end

  def create
    @location = Location.new(location_parrams)

    if @location.valid?
      @location.save
      render json: @location
    else
      render json: @location.errors
    end
  end

  def show; end

  # def update
  #   if @location.update(location_parrams)
  #     render json: @location
  #   else
  #     render json: @location.errors
  #   end
  # end

  # def destroy
  #   @location.destroy!
  #   render json: I18n.t('locations.removal.success')
  # rescue StandardError => e
  #   render json: e.message
  # end

  def list
    @lat = params[:latitude].to_f
    @long = params[:longitude].to_f
    @dist = params[:distance].to_i
    @locations = Location.near([@lat, @long], @dist, units: :km, order: :name)
  end

  def map
    @lat = params[:latitude].to_f
    @long = params[:longitude].to_f
    @dist = params[:distance].to_i
    @locations = Location.near([@lat, @long], @dist, units: :km, order: :distance)
  end

  private

  def find_location
    @location = Location.where(id: params[:id]).first
  end

  def location_parrams
    params.require(:location).permit(:name, :street, :number, :complement, :city, :state, :zip_code)
  end
end
