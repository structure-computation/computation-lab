# encoding: utf-8

class Users::ConfirmationsController < Devise::ConfirmationsController
  # include Devise::Controllers::InternalHelpers
  # TODO: Vérifier que la suppression de la ligne ci-dessus (passage à une nouvelle version de devise)
  # ne perturbe pas le fonctionnement.
  layout 'workspace'

  # GET /resource/confirmation/new
  def new
    build_resource({})
    render '/devise/confirmations/new'
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) #if is_navigational_format?
      redirect_to after_resending_confirmation_instructions_path_for(resource_name)
    else
      set_flash_message(:notice, "Ce compte ne peut pas être réinitialisé !")
      redirect_to new_confirmation_path(resource_name, resource)
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) #if is_navigational_format?
      sign_in(resource_name, resource)
      redirect_to new_session_path(resource_name, resource)
    else
      set_flash_message(:notice, "Ce compte ne peut pas être réinitialisé !")
      redirect_to new_confirmation_path(resource_name, resource)
    end
  end

  protected

    # The path used after resending confirmation instructions.
    def after_resending_confirmation_instructions_path_for(resource_name)
      new_session_path(resource_name)
    end
end