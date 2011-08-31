class ScAdminCompanyController < ApplicationController
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'company'
  
  def index 
    @page = 'SCadmin'
    @companys = Workspace.all
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @companys.to_json}
    end
  end
  
  def create
    @new_company = Workspace.create(params[:workspace])
    @new_company.init_account
    render :json => { :result => 'success' }
  end
end
