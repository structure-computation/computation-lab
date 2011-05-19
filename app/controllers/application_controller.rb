class ApplicationController < ActionController::Base
#   protect_from_forgery
  def valid_admin_user
    admin_company = ScAdmin.find(:first)
    admin_user = admin_company.user_sc_admins.find(:first, :conditions => {:user_id => current_user.id})
    if admin_user
      
    else
      redirect_back_or_default('/accueil')
    end
  end
  
  
end
