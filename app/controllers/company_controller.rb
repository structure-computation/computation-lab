class CompanyController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'SCmanage' 
    @current_company = Company.find(@current_user.company_id)
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_company.to_json}
    end
  end

  def list_membre
    @users = User.find(:all, :conditions => {:company_id => session[:current_company_id]})
    render :json => @users.to_json
  end
  
  
  def get_gestionnaire
    #recherche des gestionnaires dans la bdd
    gestionnaire = User.find(:all, :conditions => {:company_id => session[:current_company_id], :role => "gestionnaire"})

    # creation du tableau des gestionnaires réduit a envoyer
    @users = []
    gestionnaire.each{ |gestionnaire_i|
      user = Hash.new
      user['user'] = Hash.new
       
      user['user'] = { :id =>gestionnaire_i.id ,:date => gestionnaire_i.created_at.to_date, :email  => gestionnaire_i.email, :name => gestionnaire_i.firstname + " " + gestionnaire_i.lastname }
      @users << user
    } 
   
    
    render :json => @users.to_json
  end
  
  
  def get_solde
    # Creation d'une liste fictive d'opération.
    @soldes = []
    (1..18).each{ |i|
      solde =    SoldeCalculAccount.new( :created_at  => i.to_s+"/03/2010", :solde_type => "calcul_"+i.to_s,  :debit_jeton => "25", :credit_jeton => "20", :solde_jeton => i.to_s )
      @soldes << solde
    } 
    render :json => @soldes.to_json
  end
  
  def get_facture
    # Creation d'une liste fictive d'opération.
    @factures = []
    (1..18).each{ |i|
      facture =    Facture.new( :created_at  => i.to_s+"/03/2010", :total_calcul => "25", :total_memory => "20", :total => "45" )
      @factures << facture
    } 
    render :json => @factures.to_json
  end
end
