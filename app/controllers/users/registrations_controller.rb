class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!
  layout 'workspace'
  
  def edit
    render '/devise/registrations/edit'
  end
  
  def update
    # Devise use update_with_password instead of update_attributes.
    # This is the only change we make.
    if resource.update_attributes(params[resource_name]) 
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      sign_in resource_name, resource #, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      redirect_to edit_registration_path(@user), :notice => "L'adresse mail déjà utilisé ou le mot de passe est éroné" # TODO traduire 
    end
  end
end