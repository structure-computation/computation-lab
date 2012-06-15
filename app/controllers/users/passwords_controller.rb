class Users::PasswordsController < Devise::PasswordsController
  layout 'login'
  
  include Devise::Controllers::InternalHelpers

  # GET /resource/password/new
  def new
    build_resource({})
    render '/devise/passwords/new'
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) #if is_navigational_format?
      redirect_to new_session_path(resource_name, resource)
    else
      set_flash_message(:notice, "Adresse mail invalide !")
      redirect_to new_password_path(resource_name, resource)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render '/devise/passwords/edit'
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])
    logger.debug resource.errors
    if resource.errors.empty?
      set_flash_message(:notice, :updated) #if is_navigational_format?
      sign_in(resource_name, resource)
      redirect_to new_session_path(resource_name, resource)
    else
      set_flash_message(:notice, "Données invalide !")
      redirect_to edit_password_path(resource_name, resource)
    end
  end
end