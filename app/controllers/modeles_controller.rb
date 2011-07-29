# This controller handles the login/logout function of the site.  
class ModelesController < InheritedResources::Base
  #session :cookie_only => false, :only => :upload
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user!
  layout 'company'
  
  def index
    @page = :lab
    list_model = current_user.sc_models
    @model_list = []
    list_model.each{ |model_i|
      model = Hash.new
      model['sc_model'] = Hash.new 
      model['sc_model'] = {:id =>model_i.id ,:project => "hors projet", :name => model_i.name, :state  => model_i.state, :results => model_i.calcul_results.find(:all, :conditions => {:log_type => "compute", :state => "finish"}).size}
      @model_list << model
    } 
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @model_list.to_json}
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
    model = current_user.sc_models.create(:name => params[:name], :dimension => params[:dimension], :description => params[:description], :company => current_user.company, :state => 'void')
    model.add_repository()
    render :text => { :result => 'success' }
  end
 
  def delete
    @id_model = params[:id_model]
    @current_model = current_user.sc_models.find(@id_model)
    if(@current_model.test_delete?)
      @current_model.delete_model()
      render :text => "true"
    else
      render :text => "false"
    end
  end
  
  
end
