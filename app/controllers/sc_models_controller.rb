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
    @sc_model = ScModel.new(params[:sc_model]) #retrieve_column_fields(params)  
    @sc_model.save                   
    @ownership = WorkspaceMemberToModelOwnership.new
    @ownership.sc_model_id = @sc_model.id
    @ownership.workspace_member = current_workspace_member
    @ownership.save    
    
    redirect_to :controller => :laboratory, :action => :index,:notice => "Nouveau modèle crée." # TODO: traduire.
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
    #     @sc_model.model_ownerships.each do |ownership|
    #       if ownership.workspace_member.nil?
    #         logger.debug ownership.id
    #         ownership.destroy
    #         if ownership.workspace_member.user.nil?
    #           logger.debug ownership.id
    #           ownership.destroy
    #         end
    #       end
    #     end
    if @sc_model 
      # show!
      render
    else
      redirect_to :controller => :laboratory, :action => :index, :notice => "Ce modèle n'existe pas ou n'est pas accessible à partir de cet espace de travail."
    end
  end          
  
  def destroy  
    @sc_model = ScModel.find(params[:id])    
    @ownership = WorkspaceMemberToModelOwnership.find(:all, :conditions => ["sc_model_id = ? AND workspace_member_id = ?" , @sc_model.id, current_workspace_member])
    #@ownership.find_by_workspace_member(current_workspace_member)    
    if !@ownership.empty?
      @sc_model.destroy
      redirect_to :controller => :laboratory, :action => :index, :notice => "Le modèle a bien été détruit."
    else
      redirect_to :controller => :laboratory, :action => :index, :notice => "Vous ne pouvez pas détruire ce modèle."
    end
  end
  
  def share 
    @sc_model  = ScModel.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    @workspace    = current_workspace_member.workspace
    @members_list = @workspace.users
    if @sc_model 
      render
    else
      redirect_to :controller => :laboratory, :action => :index, :notice => "Ce modèle n'existe pas ou n'est pas accessible à partir de cet espace de travail."
    end
  end  
  
  def valid_share
    @sc_model  = ScModel.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:id])
    @workspace    = current_workspace_member.workspace
    @members = @workspace.users.find(params[:member_id])
    if @sc_model.workspace_members.where(:user_id => @members.id).exists?
      #if @sc_model.workspace_members.exists?(:first, :conditions => {:user_id => @members.id})
      redirect_to workspace_sc_model_path(@sc_model.id), :notice => "Cet utilisateur a déjà accès à ce modèle."
    else
      @sc_model.workspace_members << @workspace.user_workspace_memberships.where(:user_id => @members.id)
      redirect_to workspace_sc_model_path(@sc_model.id), :notice => "Utilisateur ajouté."
    end
  end
  

end
