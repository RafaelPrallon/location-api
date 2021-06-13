# Class to handle registrations trough API
class RegistrationsController < Devise::RegistrationsController
  respond_to :json

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
