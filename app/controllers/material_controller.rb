class MaterialController < ApplicationController
  #session :cookie_only => false, :only => :upload
  def index 
    @materials = []
    (1..5).each{ |i|
      mat =    Material.new(:name => "Nom materiaux " + i.to_s,   :mtype =>  'isotrope',  :comp => 'el pl') 
      @materials << mat
    }
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @materials.to_json}
    end
  end
end
