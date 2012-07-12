class MaterialsController < InheritedResources::Base
  helper :all
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  before_filter :must_be_engineer
  before_filter :set_page_name
  belongs_to    :workspace 
  
  
  layout        'workspace'
  respond_to    :html, :json

  def set_page_name
    @page = :lab
  end

  def index 
    @workspace           = current_workspace_member.workspace
    @standard_materials  = Material.standard  
    @workspace_materials = Material.from_workspace params[:workspace_id]
    index!      
  end         
  
  def update
    # Test pour savoir si les informations sont données en brut (en JSON, envoyées par le javascript)
    @workspace           = current_workspace_member.workspace
    if params[:material].nil?
      @material = Material.find(params[:id])
      @material.update_attributes! retrieve_column_fields(params)
    end
    update! { workspace_material_path (@workspace, @material)}
  end
  
  def create
    if params[:material].nil?
      @material = Material.create retrieve_column_fields(params)
    end
    create! { {:controller => :laboratory, :action => :index, :anchor => 'Matériaux'} }
  end
  
  def edit
    @workspace           = current_workspace_member.workspace
    @material = Material.find(params[:id])
    if @material.workspace_id == -1
      flash[:notice] = "Vous n'avez pas le droit d'éditer ce materiaux !"
      redirect_to workspace_material_path(@workspace, @material)
    else
      edit!
    end
  end
  
  # Essayer de faire une ressources accessibles par /material
  def show
    @workspace           = current_workspace_member.workspace
    std_material = Material.standard.find_by_id(params[:id])
    ws_material  = Material.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    # We take the ws_material if not nil, the ws_material otherwise
    @material    = std_material ? std_material : ws_material
    # If we have a material, it is rendered, otherwise we send an error (forbidden or missing, ).  
    if @material 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to workspace_materials_path(current_workspace_member.workspace.id), 
                    :notice => "Ce matériel n'existe pas ou n'est pas accessible à partir de cet espace de travail."}
        format.json {render :status => 404, :json => {}}
      end
    end 
  end

  def new
    @workspace           = current_workspace_member.workspace
    if params[:type]
      @material = Material.new
      @material.mtype = "isotrope" if params[:type].include? "Isotrope"
      @material.mtype = "orthotrope" if params[:type].include? "Orthotrope"
      @material.mtype = "orthotrope" if params[:type].include? "Mésomodèle"
      @material.comp  = ""
      @material.comp += "el " if params[:type].include? "Elastique"
      @material.comp += "pl " if params[:type].include? "Plastique"
      @material.comp += "en " if params[:type].include? "Endomageable"
      @material.comp += "vi " if params[:type].include? "Visqueux"
      @material.comp += "mes " if params[:type].include? "Mésomodèle"
    end
    new!
  end

  def destroy
    @workspace           = current_workspace_member.workspace
    @material            = Material.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    @material.destroy
    redirect_to :controller => :laboratory, :action => :index, :anchor => 'Matériaux'
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
