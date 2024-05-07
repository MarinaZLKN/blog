class RegistrationsController < Devise::RegistrationsController

  # found this solution on stackowerflow, it hepls :D
  before_action :configure_permitted_parameters

  # I understand that since I'm using Devise to create the Author instances, the user creation process should happen
  # somewhere here and I need to delve deeper into the underlying mechanics(I commented out the create method in the
  # Author controller as it was unnecessary) To be honest, I will need either more time or the help
  # of a more experienced developer. Generally, author entities are created, deleted, and edited without issues.
  # However, I have encountered difficulties in integration tests with error messages, which has led me to repaet some
  # test logic in the system tests.

  def create
    super do |resource|
      Rails.logger.debug "Resource created: #{resource.persisted?}"
      Rails.logger.debug "Errors: #{resource.errors.full_messages.join(", ")}"
    end
  end

  # def create
  #   super do |resource|
  #     if resource.errors.any?
  #       Rails.logger.debug "Errors: #{resource.errors.full_messages.join(", ")}"
  #       render :new, status: :unprocessable_entity
  #     end
  #   end
  # end


  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :password_confirmation, :current_password])
  end
end
