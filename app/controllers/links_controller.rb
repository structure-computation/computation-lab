class LinksController < InheritedResources::Base
  
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  before_filter :set_page_name
  belongs_to    :company
  layout 'company'
  
  def set_page_name
    @page = :bibliotheque
  end
  
  def index 
    @company  = current_company_member.company
    if params[:type] == "standard"
      @links = Link.standard
    else
      @links = Link.find_all_by_company_id(@company.id)
    end
    index!
  end
  
  def create
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
    if @link.company_id == -1
      render :action => "show"
    elsif @link.company_id == current_company_member.company.id
      render :action => "show"
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

end