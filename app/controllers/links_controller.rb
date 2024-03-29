# encoding: utf-8

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
    update! { workspace_link_path(@workspace, @link) }
  end
  
  def create
    if params[:link].nil?
      @link = Link.create retrieve_column_fields(params)
    end
    create! { {:controller => :laboratory, :action => :index, :anchor => 'Liaisons'} }
  end

  def edit
    @workspace           = current_workspace_member.workspace
    @link = Link.find(params[:id])
    @disable = false
    if @link.workspace_id == -1
      flash[:notice] = "Vous n'avez pas le droit d'éditer cette liaison !"
      redirect_to workspace_link_path(@workspace, @link)
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
    @disable = true
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
    @disable = false
    if params[:next]
      @link = Link.new
      @link.comp_generique = "Pa " if params[:type].include? "Parfaite"
      @link.comp_generique = "El " if params[:type].include? "Elastique"
      @link.comp_generique = "Con " if params[:type].include? "Contact"
      @link.comp_generique = "Coh " if params[:type].include? "Cohésive"

      @link.comp_complexe  = ""
      @link.comp_complexe += "Pl " if params[:type].include? "Plastique"
      @link.comp_complexe += "Ca " if params[:type].include? "Cassable"
 
      #["Parfaite", "Elastique", "Contact", "Parfaite Cassable", "Elastique Cassable", "Cohésive"]
      @link.type_num = 0 if params[:type] == "Parfaite"
      @link.type_num = 1 if params[:type] == "Elastique"
      @link.type_num = 2 if params[:type] == "Contact"
      @link.type_num = 3 if params[:type] == "Parfaite Cassable"
      @link.type_num = 4 if params[:type] == "Elastique Cassable"
      @link.type_num = 5 if params[:type] == "Cohésive"
    end
    #if params[:next] and (@link.comp_generique.empty?)
    #  flash[:notice] = "Vous avez mal rempli le formulaire."
    #  redirect_to new_workspace_link_path(@workspace)
    #else
    #  new!
    #end
    new!
  end
  
  def destroy
    @workspace          = current_workspace_member.workspace
    @link               = Link.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    @link.destroy
    redirect_to :controller => :laboratory, :action => :index, :anchor => 'Liaisons'
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