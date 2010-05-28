class ScAdminCompanyController < ApplicationController
  before_filter :login_required
  
  def index 
    @page = 'SCadmin'
    @companys = Company.all
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @companys.to_json}
    end
  end
  
  def create
    num_model = 1
    File.open("#{RAILS_ROOT}/public/test/company_#{num_model}", 'w+') do |f|
        f.write(params.to_json)
    end
    render :json => { :result => 'success' }
  end
end
