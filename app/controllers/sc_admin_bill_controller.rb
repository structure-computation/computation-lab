class ScAdminBillController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  before_filter :set_page_name
  
  layout 'sc_admin'
  
  def set_page_name
    @page = :sc_admin_bill
  end
  
   def index 
    @bills = Bill.find(:all, :conditions => {:statut => "unpaid"}, :order => " created_at DESC" )
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def show 
    @bill      = Bill.find(params[:id])   
    if @bill.statut == "canceled"
      redirect_to :action => :index, :notice => "La facture a été annulée" # TODO traduire 
    else        
      render
    end                             
  end 
  
  def cancel 
    @bill      = Bill.find(params[:id]) 
    @bill.cancel_bill()        
    redirect_to :action => :index, :notice => "La facture a été annulée" # TODO traduire                            
  end 
  
  def valid 
    @bill      = Bill.find(params[:id]) 
    @bill.valid_bill()
    redirect_to sc_admin_workspace_path(@bill.workspace), :notice => "La facture a été payée" # TODO traduire                                 
  end 
  
  def download_bill
    @bill      = Bill.find(params[:id]) 
    name_file = "#{SC_FACTURE_ROOT}/facture_" + params[:id] + ".pdf"
    name_bill = 'Facture_' + @bill.ref.to_s() + '.pdf'
    send_file name_file, :filename => name_bill
  end
  
end
