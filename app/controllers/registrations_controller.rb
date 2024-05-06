class RegistrationsController < Devise::RegistrationsController

  # found this solution on stackowerflow, it hepls :D
  before_action :configure_permitted_parameters

  def create
    super do |resource|
      Rails.logger.debug "Resource created: #{resource.persisted?}"
      Rails.logger.debug "Errors: #{resource.errors.full_messages.join(", ")}"
    end
  end


  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :password_confirmation, :current_password])
  end

  # def sign_up_params
  #   params.require(:author).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  # end

  # def account_update_params
  #   params.require(:author).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  # end
end
