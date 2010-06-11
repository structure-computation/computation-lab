class FacturesController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'SCmanage' 
    @current_company = @current_user.company
    @id_company = @current_company.id
    respond_to do |format|
      format.html {render :layout => true }
    end
  end
  
  
  def get_facture
    # Creation d'une liste fictive d'opération.
    @factures = []
    (1..18).each{ |i|
      facture =    Facture.new( :total_calcul => "25", :total_memory => "20", :total => "45" )
      @factures << facture
    } 
    render :json => @factures.to_json
  end
end
