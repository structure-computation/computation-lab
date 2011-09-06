class LinksController < InheritedResources::Base
  helper :all
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  before_filter :set_page_name
  belongs_to    :workspace
  layout 'company'
  respond_to :html, :json
  
  def set_page_name
    @page = :bibliotheque
  end
  
  def index 
    @company  = current_user.workspace
    @standard_links = Link.standard
    @company_links  = Link.from_workspace @workspace.id
    index!
  end
  
  def update
    # Test pour savoir si les informations sont données en brut (en JSON, envoyées par le javascript)
    if params[:link].nil?
      @link = Link.find(params[:id])
      @link.update_attributes! retrieve_column_fields(params)
    end
    update! { workspace_links_path }
  end
  
  def create
    if params[:link].nil?
      @link = Link.create retrieve_column_fields(params)
    end
    create! { workspace_links_path }
  end

  def edit
    @link = Link.find(params[:id])
    if @link.workspace_id == -1
      flash[:notice] = "Vous n'avez pas le droit d'éditer cette liaison !"
      redirect_to workspace_materials_path
    else
      edit!
    end
  end

  def show
    @link = Link.find(params[:id])

    # TODO: Revoir le controle d'accès, cela ne se fait pas comme ça mais plutôt comme :
    # current_workspace.links.find params[:id]
    # De plus je ne vois pas ici comment l'on affiche un lien de la lib standard.
    @workspace = Workspace.find(params[:workspace_id])
    if @link.workspace_id == current_user.workspace.id
      show!
    else
      flash[:notice] = "Vous n'avez pas accès à cette liaison !"
      redirect_to workspace_links_path
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
      redirect_to new_workspace_link_path
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