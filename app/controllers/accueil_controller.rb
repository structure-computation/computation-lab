class AccueilController < ApplicationController
  def index
    @page = 'Accueil'
    @user =    User.new( :email  => "prenom.nom@societe.com", :firstname => "prenom",  :lastname => "nom" )
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @user.to_json}
    end
  end
end
