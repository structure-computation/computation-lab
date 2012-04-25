class ForfaitController < InheritedResources::Base
  before_filter :authenticate_user!  
  before_filter :must_be_manager
  before_filter :set_page_name
  
  layout 'workspace'
  
  def set_page_name
    @page = :manage
  end
  
  def index
    @workspace  = current_workspace_member.workspace
    @forfaits  = Forfait.find(:all, :conditions => {:state => "active"})
  end
  
  def show
    @workspace  = current_workspace_member.workspace
    @forfait    = Forfait.find_by_id(params[:id])
  end
  
  def new
    @workspace  = current_workspace_member.workspace
    @forfait    = Forfait.find(params[:id])
    #redirect_to workspace_path(@workspace), :notice => "Nouveau forfait souscrit, une facture a été générée. " + @forfait.id.to_s # TODO traduire 
    @credit = @workspace.token_account.credits.build()
    @credit.new_credit_and_bill(@forfait.id)
    if @credit 
      redirect_to workspace_path(@workspace), :notice => "Nouveau forfait souscrit, une facture a été générée." # TODO traduire 
    else
      redirect_to workspace_path(@workspace), :notice => "Suite à un problème, le nouveau forfait n'a pas été souscrit. vauillez recommencer l'opération" # TODO traduire 
    end 
  end
  
end
