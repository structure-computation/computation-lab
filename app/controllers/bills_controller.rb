class BillsController < InheritedResources::Base
  before_filter :authenticate_user!
  respond_to :html, :json
  belongs_to :company
  actions :index, :show, :new, :create
  
  #TODO remplacer chargement JSON par chargement normal (sans requête ajax)
  # def index
  #   @id_company = @current_company.id
  #   #@current_gestionnaire = @current_company.users.find(:first, :conditions => {:role => "gestionnaire"})
  # 
  #   @bills_forfaits = []
  #   @bills.each{ |bill_i|
  #     bill_forfait = Hash.new
  #     bill_forfait['facture'] = Hash.new
  #     bill_forfait['facture'] = { :id =>bill_i.id, 
  #                                 :ref =>bill_i.ref,
  #                                 :date => bill_i.created_at.to_date.to_s(),
  #                                 :price_calcul_HT  => bill_i.price_calcul_HT,
  #                                 :price_calcul_TVA  => bill_i.price_calcul_TVA,
  #                                 :price_calcul_TTC  => bill_i.price_calcul_TTC,
  #                                 :price_memory_HT  => bill_i.price_memory_HT,
  #                                 :price_memory_TVA  => bill_i.price_memory_TVA,
  #                                 :price_memory_TTC  => bill_i.price_memory_TTC,
  #                                 :total_price_HT  => bill_i.total_price_HT,
  #                                 :total_price_TVA  => bill_i.total_price_TVA,
  #                                 :total_price_TTC  => bill_i.total_price_TTC,
  #                                 :statut  => bill_i.statut,
  #                                 :facture_type => bill_i.facture_type }
  #                 
  #     bill_forfait['forfait'] = Hash.new
  #     bill_forfait['abonnement'] = Hash.new
  #     if(bill_i.facture_type == 'calcul')
  #       bill_forfait['forfait'] = { :name =>bill_i.credit.forfait.name,
  #                                   :nb_jetons =>bill_i.credit.forfait.nb_jetons,
  #                                   :nb_jetons_tempon  => bill_i.credit.forfait.nb_jetons_tempon,
  #                                   :validity  => bill_i.credit.forfait.validity }
  #     elsif(bill_i.facture_type == 'memoire')
  #       bill_forfait['abonnement'] = { :name =>bill_i.log_abonnement.abonnement.name,
  #                                      :assigned_memory =>bill_i.log_abonnement.abonnement.assigned_memory,
  #                                      :security_level  => bill_i.log_abonnement.abonnement.security_level,
  #                                      :nb_max_user  => bill_i.log_abonnement.abonnement.nb_max_user }        
  #     end
  #     @bills_forfaits << bill_forfait
  #   } 
  # end
  
  def show
    @company = Company.find(params[:company_id])
    @manager = @company.users.find(:first, :conditions => {:role => "gestionnaire"})
    show!
  end

  def download_bill
    @current_company = current_user.company
    @current_bill = @current_company.bills.find(params[:id])
    name_file = "#{SC_FACTURE_ROOT}/facture_" + params[:id] + ".pdf"
    name_bill = 'Facture_' + @current_bill.ref.to_s() + '.pdf'
    send_file name_file, :filename => name_bill
  end

 def generate_pdf_facture
    @current_company = current_user.company
    @current_bill = @current_company.bills.find(params[:id_facture])
    @current_gestionnaire = @current_company.users.find(:first, :conditions => {:role => "gestionnaire"})
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
