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
    @model.users   << current_user
    @model.company = current_user.company
    create!
  end

  def new
    @model = Model.new
#    @model.add_repository()
    new!
  end
  
  
end
