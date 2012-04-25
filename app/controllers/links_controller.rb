class LinksController < InheritedResources::Base
  helper :all
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  before_filter :set_page_name
  before_filter :must_be_engineer
  belongs_to    :workspace
  layout 'workspace'
  respond_to :html, :json
  
  def set_page_name
    @page = :lab
  end
  
  def index 
    @workspace        = current_workspace_member.workspace
    @standard_links   = Link.standard
    @workspace_links  = Link.from_workspace @workspace.id
    index!
  end
  
  def update
    # Test pour savoir si les informations sont données en brut (en JSON, envoyées par le javascript)
    @workspace           = current_workspace_member.workspace
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
    # On préfère find_by_id qui renvoie nil si aucun enregistrement n'est trouvé car il y a au moins une 
    # des deux ligne renvoyant nil (une liaison ne peux être standard et appartenir à un Workspace).
    std_link  = Link.standard.find_by_id(params[:id])
    ws_links  = Link.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    
    # We take the std_link if not nil, the ws_link otherwise
    @link     = std_link ? std_link : ws_links
    @workspace        = current_workspace_member.workspace
    # If we have a link, it is rendered, otherwise we send an error (forbidden or missing, ).  
    if @link 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to workspace_links_path(current_workspace_member.workspace.id), 
                    :notice => "Ce lien n'existe pas ou n'est pas accessible à partir de cet espace de travail."}
        format.json {render :status => 404, :json => {}}
      end
    end
     
  end

  def new
    # Le paramètre next signifie que l'utilisateur vient du premier formulaire 
    # dans lequel il doit spécifier si la liaison est parfaite, elastique, plastique etc.
    # Je crée une liaison et lui affecte les paramètres pour que les bonne partie du formulaire soit visible dans l'étape d'après.
    @workspace           = current_workspace_member.workspace
    if params[:next]
      @link = Link.new
      @link.comp_generique = "Pa " if params[:type].include? "Parfaite"
      @link.comp_generique = "El " if params[:type].include? "Elastique"
      @link.comp_generique = "Co " if params[:type].include? "Contact"

      @link.comp_complexe  = ""
      @link.comp_complexe += "Pl " if params[:Plastique]
      @link.comp_complexe += "Ca " if params[:Cassable]
 
      @link.type_num = 0 if params[:type].include? "Parfaite"
      @link.type_num = 1 if params[:type].include? "Elastique"
      @link.type_num = 2 if params[:type].include? "Contact"
    end
    #if params[:next] and (@link.comp_generique.empty?)
    #  flash[:notice] = "Vous avez mal rempli le formulaire."
    #  redirect_to new_workspace_link_path(@workspace)
    #else
    #  new!
    #end
    new!
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