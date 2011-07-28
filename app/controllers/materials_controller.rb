class MaterialsController < InheritedResources::Base
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  respond_to :html, :js
  
  def index 
    @page = 'SCcompute'
    @current_company = current_user.company
    if params[:type] == "standard"
      @materials = Material.standard
    else
      @materials = Material.find_all_by_company_id(@current_company.id)
    end

    respond_to do |format|
      format.html #{render :layout => true }
      if params[:type] == "standard"
        format.js { render :json => @standard_materials.to_json }  # matériaux standards
      else
        format.js { render :json => @materials.to_json }
      end
    end
  end
  
  def create
    @current_company = current_user.company
    @new_material = @current_company.materials.build(params[:material])
    @new_material.save
    render :json => { :result => 'success' }
  end

  def new
    if params[:type]
      @material = Material.new
      @material.mtype = params[:type].downcase
      @material.comp = ""
      if params[:Elastique]
        @material.comp += "el "
      end
      if params[:Plastique]
        @material.comp += "pl "
      end
      if params[:Endomageable]
        @material.comp += "en "
      end
      if params[:Visqueux]
        @material.comp += "vi "
      end
    end
    new!
  end
  
end
