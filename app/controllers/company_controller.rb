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
end
