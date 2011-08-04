class ApplicationController < ActionController::Base
  helper :all
#   protect_from_forgery
  def valid_admin_user
    admin_company = ScAdmin.find_by_company_id(current_user.company.id)
    admin_user = admin_company.user_sc_admins.find(:first, :conditions => {:user_id => current_user.id})
    if !admin_user
      redirect_back_or_default(root_path)
    end
  end
  
  
end
