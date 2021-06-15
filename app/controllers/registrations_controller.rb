# Class to handle registrations through API
class RegistrationsController < Devise::RegistrationsController
  resource_description do
    short "Endpoints for methods related to user's sign up"
  end
  respond_to :json

  api :POST, 'signup'
  param :user, Hash do
    param :email, String, required: true
    param :username, String, required: true
    param :password, String, required: true
  end
  def create
    build_resource(sign_up_params)

    resource.save

    if resource.errors.empty?
      render json: resource
    else
      render json: resource.errors
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :username, :password)
  end
end
