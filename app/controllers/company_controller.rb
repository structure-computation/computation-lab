class CompanyController < ApplicationController
  
  def index
    @page = 'SCmanage' 
  end

  def list_membre
    # Creation d'une liste fictive d'utilisateur pour l'affichage.
    @users = []
    (1..5).each{ |i|
      user =    User.new( :email  => "prenom.nom_"+i.to_s+"@societe.com", :firstname => "prenom_"+i.to_s,  :lastname => "nom_"+i.to_s )
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
      facture =    Facture.new( :created_at  => i.to_s+"/03/2010",  :total_calcul => "25", :total_memory => "20", :total => "45" )
      @factures << facture
    } 
    render :json => @factures.to_json
  end
end
