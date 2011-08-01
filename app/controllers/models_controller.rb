# This controller handles the login/logout function of the site.  
class ModelsController < InheritedResources::Base
  #session :cookie_only => false, :only => :upload
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user!
  before_filter :set_page_name
  belongs_to :company

  layout 'company'
#  belongs_to :member
  
  def set_page_name
    @page = :lab
  end

  def index
    # @page = :lab
    # 
    @models = current_user.models
    @models.each{ |model|
      model[:results]  = model.calcul_results.find(:all, :conditions => {:log_type => "compute", :state => "finish"}).size
    #   model[:project] = "hors projet"
    }
    index!
  end
  
  def create
    num_model = 1
    # File.open("#{RAILS_ROOT}/public/test/test_post_create_#{num_model}", 'w+') do |f|
    #     f.write(params[:json])
    # end
    @model = Model.new(params[:model])
    @user_model_information = UserModelInformation.create(:model => @model , :user => current_user, :rights => "all") 
    respond_to do |format|
      if @model.save
    	  format.html { redirect_to( :action => :index , :notice => 'Le modèle à bien été créé') }
      else
   	    format.html { render :action => "new" }
      end
    end
  end

  # TODO: Uncomment for production
  def new
    @model = Model.new
#    @model.add_repository()
    new!
  end

  def show
    show!
  end
  
  def load_mesh
    @model = Model.find(params[:id])
    if params[:model].nil?
      flash[:error] = "Vous n'avez pas séléctionné de fichier !"
    else
      @model.send_mesh(params[:model][:file], current_user) unless params[:model][:file].nil?
    end
    redirect_to company_model_path(@model)
  end

end
