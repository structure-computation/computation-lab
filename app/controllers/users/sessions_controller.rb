# This controller handles the login/logout function of the site.  
class Users::SessionsController < Devise::SessionsController
  

  # render new.rhtml
  def new
    clean_up_passwords(build_resource)
    render '/devise/sessions/new', :layout => false 
  end

  # def create
  #   logout_keeping_session!
  #   user = User.authenticate(params[:login], params[:password])
  #   if user
  #     # Protects against session fixation attacks, causes request forgery
  #     # protection if user resubmits an earlier form using back
  #     # button. Uncomment if you understand the tradeoffs.
  #     # reset_session
  #     self.current_user = user
  #     # current_company = user.Company.find(current_user.company_id)
  #     current_company = user.company
  #     session[:current_user_name] = current_user.firstname + " " + current_user.lastname
  #     session[:current_company_name] = current_company.name
  #     session[:current_company_id] = current_company.id
  #     new_cookie_flag = (params[:remember_me] == "1")
  #     handle_remember_cookie! new_cookie_flag
  #     redirect_back_or_default('/accueil')
  #     flash[:notice] = "Logged in successfully"
  #   else
  #     note_failed_signin
  #     @login       = params[:login]
  #     @remember_me = params[:remember_me]
  #     render :action => 'new', :layout => false 
  #     flash[:notice] = "Logged not successfully"
  #   end
  # end
  # 
  # def destroy
  #   logout_killing_session!
  #   flash[:notice] = "You have been logged out."
  #   redirect_back_or_default('/login')
  # end

protected
  # Track failed login attempts
  # def note_failed_signin
  #   flash[:error] = "Couldn't log you in as '#{params[:login]}'"
  #   logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  # end
end