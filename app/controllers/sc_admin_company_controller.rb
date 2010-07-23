class ScAdminCompanyController < ApplicationController
  before_filter :login_required
  before_filter :valid_admin_user
  
  def index 
    @page = 'SCadmin'
    @companys = Company.all
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @companys.to_json}
    end
  end
  
  def create
    @new_company = Company.create(params[:company])
    @new_company.init_account
    render :json => { :result => 'success' }
  end
end
