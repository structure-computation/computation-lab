class LinkController < ApplicationController
  #session :cookie_only => false, :only => :upload
  def index 
    @page = 'SCcompute'
    @links = []
    (1..5).each{ |i|
      liaison =    Link.new(:name => "Nom liaison " + i.to_s, :comp_generique => "El", :comp_complexe => "Pl Ca")
      @links << liaison
    }
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @links.to_json}
    end
  end
end
