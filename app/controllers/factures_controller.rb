class FacturesController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'SCmanage' 
    @current_company = @current_user.company
    @id_company = @current_company.id
    @current_gestionnaire = @current_company.users.find(:first, :conditions => {:role => "gestionnaire"})
    respond_to do |format|
      format.html {render :layout => true }
    end
  end
  
  def get_facture
    @current_company = @current_user.company
    @factures = @current_company.factures.find(:all)
    @current_gestionnaire = @current_company.users.find(:first, :conditions => {:role => "gestionnaire"})
    @factures_forfaits = []
    @factures.each{ |facture_i|
      facture_forfait = Hash.new
      facture_forfait['facture'] = Hash.new
      facture_forfait['facture'] = { :id =>facture_i.id , :ref =>facture_i.ref ,:date => facture_i.created_at.to_date.to_s(), :price_calcul_HT  => facture_i.price_calcul_HT, 					:price_calcul_TVA  => facture_i.price_calcul_TVA,					:price_calcul_TTC  => facture_i.price_calcul_TTC,					:price_memory_HT  => facture_i.price_memory_HT,						:price_memory_TVA  => facture_i.price_memory_TVA,					:price_memory_TTC  => facture_i.price_memory_TTC,						:total_price_HT  => facture_i.total_price_HT,						:total_price_TVA  => facture_i.total_price_TVA,						:total_price_TTC  => facture_i.total_price_TTC,							:statut  => facture_i.statut, :facture_type => facture_i.facture_type}
                  
      facture_forfait['forfait'] = Hash.new
      facture_forfait['abonnement'] = Hash.new
      if(facture_i.facture_type == 'calcul')
	facture_forfait['forfait'] = { :name =>facture_i.credit.forfait.name ,			:nb_jetons =>facture_i.credit.forfait.nb_jetons, 					:nb_jetons_tempon  => facture_i.credit.forfait.nb_jetons_tempon, 					:validity  => facture_i.credit.forfait.validity}
      elsif(facture_i.facture_type == 'memoire')
        facture_forfait['abonnement'] = { :name =>facture_i.log_abonnement.abonnement.name ,			:assigned_memory =>facture_i.log_abonnement.abonnement.assigned_memory, 				:security_level  => facture_i.log_abonnement.abonnement.security_level, 				:nb_max_user  => facture_i.log_abonnement.abonnement.nb_max_user}        
      end
        
      @factures_forfaits << facture_forfait
    } 
    render :json => @factures_forfaits.to_json
  end
  
  def download_facture
    @current_company = @current_user.company
    @current_facture = @current_company.factures.find(params[:id_facture])
    name_file = "#{SC_FACTURE_ROOT}/facture_" + params[:id_facture] + ".pdf"
    name_facture = 'Facture_' + @current_facture.ref.to_s() + '.pdf'
    send_file name_file, :filename => name_facture
  end
  
  def generate_pdf_facture
    @current_company = @current_user.company
    @current_facture = @current_company.factures.find(params[:id_facture])
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
