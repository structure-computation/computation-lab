class AccueilController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'Accueil'
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_user.to_json}
    end
  end
end
