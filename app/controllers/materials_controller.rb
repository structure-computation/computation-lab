class MaterialsController < InheritedResources::Base
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  belongs_to    :company
  #respond_to    :json
  layout 'company'

  def index 
    @page = 'SCcompute'
    @company = current_user.company
    if params[:type] == "standard"
      @materials = Material.standard
    else
      @materials = Material.find_all_by_company_id(@company.id)
    end
    index!
  end
  
  def create
    create! { company_materials_path }
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
    if @material.company_id == -1
      render :action => "show"
    elsif @material.company_id == current_user.company.id
      render :action => "show"
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
  
end
