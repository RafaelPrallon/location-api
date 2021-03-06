class LocationsController < ApplicationController
  resource_description do
    short 'Endpoints for methods related to locations'
  end
  before_action :authenticate_user!
  before_action :find_location, only: %i[show update destroy]
  respond_to :json

  def_param_group :location do
    property :id, :number, desc: "location's id"
    property :name, String, desc: "location's name"
    property :street, String, desc: 'Street'
    property :number, String, desc: 'Number'
    property :complement, String, desc: 'Complement'
    property :city, String, desc: 'City'
    property :state, String, desc: 'State'
    property :latitude, :decimal, desc: "Location's latitude"
    property :longitude, :decimal, desc: "Location's longitude"
  end

  def_param_group :location_with_rating do
    property :id, :number, desc: "location's id"
    property :name, String, desc: "location's name"
    property :street, String, desc: 'Street'
    property :number, String, desc: 'Number'
    property :complement, String, desc: 'Complement'
    property :city, String, desc: 'City'
    property :state, String, desc: 'State'
    property :latitude, :decimal, desc: "Location's latitude"
    property :longitude, :decimal, desc: "Location's longitude"
    property :rating, :decimal, desc: "Average of location's rating"
  end

  def_param_group :location_with_distance do
    property :id, :number, desc: "location's id"
    property :name, String, desc: "location's name"
    property :street, String, desc: 'Street'
    property :number, String, desc: 'Number'
    property :complement, String, desc: 'Complement'
    property :city, String, desc: 'City'
    property :state, String, desc: 'State'
    property :latitude, :decimal, desc: "Location's latitude"
    property :longitude, :decimal, desc: "Location's longitude"
    property :rating, :decimal, desc: "Average of location's rating"
    property :distance, :decimal, desc: 'Distance from provided location'
  end

  api :GET, 'locations', 'list all locations by creation order'
  returns array_of: :location_with_rating, code: 200, desc: 'All locations by creation'
  def index
    @locations = Location.all
    render json: @locations
  end

  api :POST, 'locations', 'create new location'
  returns :location, code: 200, desc: "Location's info"
  param :location, Hash do
    param :name, String, required: true
    param :street, String, required: true
    param :number, String, required: true
    param :complement, String
    param :city, String, required: true
    param :state, /\A[A-Z]{2}\z/, required: true
    param :zip_code, /\A\d{8}\z/, required: true
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

  api :GET, 'locations/:id', 'show a registered location'
  returns :location, code: 200, desc: "Location's info"
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

  # distance is called at the list method in order to limit results
  api :POST, 'locations/list', 'list all locations in a given distance of a provided location sorted by name'
  param :latitude, :decimal, desc: 'Latitude', required: true
  param :longitude, :decimal, desc: 'Longitude', required: true
  param :distance, :number, desc: 'Distance in kilometers', required: true
  returns :location_with_rating, code: 200, desc: "Location's info"
  def list
    @lat = params[:latitude].to_f
    @long = params[:longitude].to_f
    @dist = params[:distance].to_i
    @locations = Location.near([@lat, @long], @dist, units: :km, order: :name)
  end

  api :POST, 'locations/map',
      'list all locations in a given distance of a provided location sorted by distance from provided place'
  param :latitude, :decimal, desc: 'Latitude', required: true
  param :longitude, :decimal, desc: 'Longitude', required: true
  param :distance, :number, desc: 'Distance in kilometers', required: true
  returns array_of: :location_with_distance, desc: 'Detailed info of location with distance from provided place'
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
