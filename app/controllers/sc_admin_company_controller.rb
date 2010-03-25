class ScAdminCompanyController < ApplicationController
  #session :cookie_only => false, :only => :upload
  def index 
    @page = 'SCmanage'
    @companys = []
    (1..5).each{ |i|
      company =    Company.new(:name => "Nom société " + i.to_s,   :city =>  'Paris',  :country => 'France') 
      @companys << company
    }
    
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
