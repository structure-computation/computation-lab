class MaterialsController < InheritedResources::Base
  helper :all
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  before_filter :set_page_name
  belongs_to    :company
  respond_to    :json
  layout 'company'

  def set_page_name
    @page = :bibliotheque
  end

  def index 
    @company = current_user.company
    @standard_materials = Material.standard
    @company_materials  = Material.user_company @company.id
    index!
  end
  
  def create
    if params[:material].nil?
      @material = Material.create retrieve_column_fields(params)
    end
    create! { company_materials_path }
  end
  
  def update
    # Test pour savoir si les informations sont données en brut (en JSON, envoyées par le javascript)
    if params[:material].nil?
      @material = Material.find(params[:id])
      @material.update_attributes! retrieve_column_fields(params)
    end
    update! { company_materials_path }
  end
  
  def edit
    @material = Material.find(params[:id])
    if @material.company_id == -1
      flash[:notice] = "Vous n'avez pas le droit d'éditer cette pièce !"
      redirect_to company_materials_path
    else
      edit!
    end
  end
  
  # Essayer de faire une ressources accessibles par /material
  def show
    @material = Material.find(params[:id])
    @company = Company.find(params[:company_id])
    if @material.company_id == -1 or @material.company_id == current_user.company.id
      respond_to do |format|
        format.html { render :action => "show"}
        format.json { render :json => @material.to_json }
      end
    # elsif @material.company_id == current_user.company.id
    #   render :action => "show"
    else
      flash[:notice] = "Vous n'avez pas accès à cette pièce !"
      redirect_to company_materials_path
    end
  end

  def new
    if params[:type]
      @material = Material.new
      @material.mtype = params[:type].downcase
      @material.comp = ""
      @material.comp += "el " if params[:Elastique]
      @material.comp += "pl " if params[:Plastique]
      @material.comp += "en " if params[:Endomageable]
      @material.comp += "vi " if params[:Visqueux]
    end
    new!
  end

  private
    def retrieve_column_fields(params)
      to_update = {}
      Material.column_names.each do |column_name|
        to_update[column_name] = params[column_name]
      end
       to_update
    end
end
