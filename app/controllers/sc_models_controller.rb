# This controller handles the login/logout function of the site.  
class ScModelsController < InheritedResources::Base
  #session :cookie_only => false, :only => :upload
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user!  
  before_filter :must_be_engineer
  before_filter :set_page_name
  belongs_to :workspace
  respond_to :html, :json
  
  layout 'workspace'
#  belongs_to :member
  
  def set_page_name
    @page = :lab
  end

  def index
    @workspace  = current_workspace_member.workspace
    @sc_models  = ScModel.from_workspace @workspace.id
    index!
  end
  
  def create
    num_model = 1
    # File.open("#{RAILS_ROOT}/public/test/test_post_create_#{num_model}", 'w+') do |f|
    #     f.write(params[:json])
    # end                          

    #Assign as user model owner when current user create a new sc_model                         
    @workspace_member_to_model_ownership = WorkspaceMemberToModelOwnership.create(:sc_model => @sc_model , :workspace_member => current_workspace_member, :rights => "all") 
    # respond_to do |format|
    #   if @sc_model.save
    #     format.html { redirect_to(:action => :index) }
    #   else
    #         format.html { render :action => "new" }
    #   end
    # end 
    #             
    if params[:sc_model].nil?
      @sc_model = ScModel.create retrieve_column_fields(params)
    end
    create! { workspace_sc_models_path }
  end

  # TODO: Uncomment for production
  def new
    @sc_model = ScModel.new
    #@sc_model.add_repository()
    new!
  end

  def show 
    @sc_model  = ScModel.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    @workspace    = current_workspace_member.workspace
    if @sc_model 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to workspace_sc_models_path(current_workspace_member.workspace.id), 
                    :notice => "Ce modèle n'existe pas ou n'est pas accessible à partir de cet espace de travail."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def load_mesh
    @sc_model = ScModel.find(params[:id])
    if params[:model].nil?
      flash[:error] = "Vous n'avez pas séléctionné de fichier !"
    else
      @sc_model.send_mesh(params[:model][:file], current_workspace_member) unless params[:model][:file].nil?
    end
    redirect_to workspace_model_path(@sc_model)
  end            
  
  def destroy 
    @sc_model  = ScModel.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    @workspace = current_workspace_member.workspace 
    @owner     = WorkspaceMemberToModelOwnership.find_by_id(params[:id])
    if @sc_model && @owner
      @sc_model.destroy!
       respond_to do |format| 
       format.html {redirect_to workspace_sc_models_path(current_workspace_member.workspace.id), 
                  :notice => "Le modèle a bien été détruit."}  
       end  
    else
      respond_to do |format|
        format.html {redirect_to workspace_sc_models_path(current_workspace_member.workspace.id), 
                    :notice => "Vous ne pouvez pas détruire ce modèle."}
        format.json {render :status => 404, :json => {}}
      end
    end

  end

end
