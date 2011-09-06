# This controller handles the login/logout function of the site.  
class ScModelsController < InheritedResources::Base
  #session :cookie_only => false, :only => :upload
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user!
  before_filter :set_page_name
  belongs_to :workspace
  respond_to :html, :json
  
  layout 'company'
#  belongs_to :member
  
  def set_page_name
    @page = :lab
  end

  def index
    @sc_models = current_workspace_member.sc_models
    @sc_models.each{ |sc_model|
      sc_model[:results]  = sc_model.calcul_results.find(:all, :conditions => {:log_type => "compute", :state => "finish"}).size }
    index!
  end
  
  def create
    num_model = 1
    # File.open("#{RAILS_ROOT}/public/test/test_post_create_#{num_model}", 'w+') do |f|
    #     f.write(params[:json])
    # end
    @sc_model = ScModel.new(params[:sc_model])
    @company_member_to_model_ownership = CompanyMemberToModelOwnership.create(:sc_model => @sc_model , :company_member => current_workspace_member, :rights => "all") 

    respond_to do |format|
      if @sc_model.save
    	  format.html { redirect_to(:action => :index) }
      else
   	    format.html { render :action => "new" }
      end
    end
  end

  # TODO: Uncomment for production
  def new
    @sc_model = ScModel.new
#    @sc_model.add_repository()
    new!
  end

  def show
    show!
  end
  
  def load_mesh
    @sc_model = ScModel.find(params[:id])
    if params[:model].nil?
      flash[:error] = "Vous n'avez pas séléctionné de fichier !"
    else
      @sc_model.send_mesh(params[:model][:file], current_workspace_member) unless params[:model][:file].nil?
    end
    redirect_to company_model_path(@sc_model)
  end

end
