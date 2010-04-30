class AccueilController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'Accueil'
    # traitement sur le current user pour l'affichage
    #user = Hash.new
    #user['user'] = Hash.new  
    #user['user'] = { :id =>@current_user.id ,:date => @current_user.created_at.to_date, :email  => @current_user.email, :firstname => @current_user.firstname, :lastname => @current_user.lastname, :name => @current_user.firstname + " " + @current_user.lastname, :role => @current_user.role, :role => @current_user.role }
    
    @current_user.created_at = @current_user.created_at.to_date
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_user.to_json}
    end
  end
end
