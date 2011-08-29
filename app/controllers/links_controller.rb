class LinksController < InheritedResources::Base
  helper :all
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  before_filter :set_page_name
  belongs_to    :company
  layout 'company'
  respond_to :html, :json
  
  def set_page_name
    @page = :bibliotheque
  end
  
  def index 
    @company  = current_user.company
    @standard_links = Link.standard
    @company_links  = Link.user_company @company.id
    index!
  end
  
  def update
    # Test pour savoir si les informations sont données en brut (en JSON, envoyées par le javascript)
    if params[:link].nil?
      @link = Link.find(params[:id])
      @link.update_attributes! retrieve_column_fields(params)
    end
    update! { company_links_path }
  end
  
  def create
    if params[:link].nil?
      @link = Link.create retrieve_column_fields(params)
    end
    create! { company_links_path }
  end

  def edit
    @link = Link.find(params[:id])
    if @link.company_id == -1
      flash[:notice] = "Vous n'avez pas le droit d'éditer cette liaison !"
      redirect_to company_materials_path
    else
      edit!
    end
  end

  def show
    @link = Link.find(params[:id])
    @company = Company.find(params[:company_id])
    if @link.company_id == current_user.company.id
      show!
    else
      flash[:notice] = "Vous n'avez pas accès à cette liaison !"
      redirect_to company_links_path
    end
  end

  def new
    if params[:next]
      @link = Link.new
      @link.comp_generique = ""
      @link.comp_generique += "Pa " if params[:Parfaite]
      @link.comp_generique += "El " if params[:Elastique]
      @link.comp_generique += "Co " if params[:Contact]

      @link.comp_complexe  = ""
      @link.comp_complexe += "Pl " if params[:Plastique]
      @link.comp_complexe += "Ca " if params[:Cassable]
    end
    if params[:next] and (@link.comp_complexe.empty? or @link.comp_complexe.empty?)
      flash[:notice] = "Vous avez mal rempli le formulaire."
      redirect_to new_company_link_path
    else
      new!
    end
  end
  
  private
    def retrieve_column_fields(params)
      to_update = {}
      Link.column_names.each do |column_name|
        to_update[column_name] = params[column_name]
      end
       to_update
    end
end