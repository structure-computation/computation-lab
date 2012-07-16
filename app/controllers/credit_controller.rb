class CreditController < InheritedResources::Base
  before_filter :authenticate_user!  
  before_filter :must_be_manager
  before_filter :set_page_name
  
  layout 'workspace'
  
  def set_page_name
    @page = :manage
  end
  
  def new
    @workspace  = current_workspace_member.workspace
    @forfait    = Forfait.find(params[:forfait_id])
    @new_company = Company.new()
  end
  
  def create
    @workspace  = current_workspace_member.workspace
    @forfait    = Forfait.find(params[:forfait_id])
    @company_id = -1
    if params[:informations] == "new"
      @company    = @workspace.companies.create(params[:company])
      @company_id = @company.id
      logger.debug @company.id
      logger.debug current_user.id
      current_user.companies << @company
      #@company.members << current_user  
    elsif params[:informations] == "exist"
      @company    = @workspace.companies.find(params[:company_id])
      if current_user.companies.exists?(@company.id)
        #@company.members << current_user
        current_user.companies << @company
      end
      @company_id = params[:company_id]
    else
      redirect_to workspace_path(@workspace), :notice => "Suite à un problème, le nouveau forfait n'a pas été souscrit. vauillez recommencer l'opération" # TODO traduire
    end
    logger.debug @company_id
    logger.debug @forfait.id
    @credit     = @workspace.token_account.credits.build()
    @credit.create_credit_and_bill(@forfait.id,@company_id)
    if @credit 
      redirect_to workspace_path(@workspace), :notice => "Nouveau forfait souscrit, une facture a été générée." # TODO traduire 
    else
      redirect_to workspace_path(@workspace), :notice => "Suite à un problème, le nouveau forfait n'a pas été souscrit. vauillez recommencer l'opération" # TODO traduire 
    end 
  end
  
end
