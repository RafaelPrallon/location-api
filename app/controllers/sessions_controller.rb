# Class to handle api sessions
class SessionsController < Devise::SessionsController
  resource_description do
    short 'Endpoints for methods related to a login'
  end
  respond_to :json

  api :POST, 'login', 'Login user'
  param :user, Hash, required: true do
    param :email, String, required: true
    param :password, String, required: true
  end
  returns code: 200, desc: 'Displays user data on body and Authorization token in Bearer format at Head' do
    property :id, Integer
    property :email, String
    property :username, String
    property :jti, String
    property :created_at, DateTime
    property :updated_at, DateTime
  end
  def create
    super
  end

  api :DELETE, 'logout', 'Logout user, require bearer token to work'
  returns code: 204, desc: "Doesn't return anything"
  def destroy
    super
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end
