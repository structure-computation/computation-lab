# This controller handles the login/logout function of the site.  
class ModeleController < ApplicationController
  #session :cookie_only => false, :only => :upload
  require 'socket'
  include Socket::Constants
  before_filter :login_required
  
  def index
    @page = 'SCcompute'
    list_model = @current_user.sc_models
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => list_model.to_json}
    end 
  end
  
  def create
    num_model = 1
    File.open("#{RAILS_ROOT}/public/test/test_post_create_#{num_model}", 'w+') do |f|
        f.write(params[:json])
    end
    render :text => { :result => 'success' }
  end

  def new
    model = @current_user.sc_models.create(:name => params[:name], :dimension => params[:dimension], :description => params[:description], :company => @current_user.company, :state => 'void')
    #model.save
    render :text => { :result => 'success' }
  end
  
end
