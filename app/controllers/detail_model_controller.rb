class DetailModelController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'SCcompute'
    @id_model = params[:id_model]
    current_model = ScModel.find(@id_model)
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => current_model.to_json}
    end 
  end
  
  def get_list_resultat
    @id_model = params[:id_model]
    current_model = ScModel.find(@id_model)
    list_resultats = CalculResult.find(:all, :conditions => {:sc_model_id => current_model.id})
    respond_to do |format|
      format.js   {render :json => list_resultats.to_json}
    end 
  end
  
end
