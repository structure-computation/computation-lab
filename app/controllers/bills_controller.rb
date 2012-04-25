class BillsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :must_be_manager
  before_filter :set_page_name
  respond_to :html, :json
  belongs_to :workspace
  actions :index, :show, :new, :create, :cancel
  layout 'workspace'
  
  def set_page_name
    @page = :manage
  end              
  
  def index 
    @workspace  = current_workspace_member.workspace
    @bills      = Bill.from_workspace @workspace.id
    index!
  end        
                                                      
  def show 
    @workspace = current_workspace_member.workspace
    @bill      = Bill.from_workspace(@workspace.id).find_by_id(params[:id])
    if @bill.statut == "canceled"
      redirect_to workspace_path(current_workspace_member.workspace), :notice => "Cette facture a été annulée" # TODO traduire 
    else        
      render
    end                                  
  end 
  
  def cancel 
    @workspace = current_workspace_member.workspace
    @bill      = Bill.from_workspace(@workspace.id).find_by_id(params[:id])
    @bill.cancel_bill()        
    redirect_to workspace_path(current_workspace_member.workspace), :notice => "La facture a été annulée" # TODO traduire                            
  end 
  
  def pay 
    @workspace = current_workspace_member.workspace
    @bill      = Bill.from_workspace(@workspace.id).find_by_id(params[:id])
    redirect_to workspace_path(current_workspace_member.workspace), :notice => "La facture a été payée" # TODO traduire                                 
  end 

  def download_bill
    @current_workspace = current_workspace_member.workspace
    @current_bill = @current_workspace.bills.find(params[:id])
    name_file = "#{SC_FACTURE_ROOT}/facture_" + params[:id] + ".pdf"
    name_bill = 'Facture_' + @current_bill.ref.to_s() + '.pdf'
    send_file name_file, :filename => name_bill
  end

  def generate_pdf_facture
    @current_workspace = current_workspace_member.workspace
    @current_bill = @current_workspace.bills.find(params[:id_facture])
    @current_gestionnaire = @current_workspace.users.find(:first, :conditions => {:role => "gestionnaire"})
    prawnto :inline => false
    prawnto :prawn => { 
                 :background => "#{RAILS_ROOT}/public/images/fond_facture.jpg", 
                 :left_margin => 0, 
                 :right_margin => 0, 
                 :top_margin => 0, 
                 :bottom_margin => 0, 
                 :page_size => 'A4' }

    respond_to do |format|
      format.pdf {render :layout => false }
    end
  end
    
end
