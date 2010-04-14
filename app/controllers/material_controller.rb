class MaterialController < ApplicationController
  #session :cookie_only => false, :only => :upload
  before_filter :login_required
  
  def index 
    @page = 'SCcompute'
    @materials = []
    (1..5).each{ |i|
      mat =    Material.new(:name => "Nom materiaux " + i.to_s,   :mtype =>  'orthotrope',  :comp => 'el') 
      @materials << mat
    }
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @materials.to_json}
    end
  end
  
  def create
    num_model = 1
    File.open("#{RAILS_ROOT}/public/test/material_#{num_model}", 'w+') do |f|
        f.write(params.to_json)
    end
    render :json => { :result => 'success' }
  end
  
end
