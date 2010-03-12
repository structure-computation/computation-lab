# This controller handles the login/logout function of the site.  
class ModeleController < ApplicationController
  #session :cookie_only => false, :only => :upload
  def index
    # Creation d'un projet et de plusieurs SC_modeles pour tester le comportement du tableau.
    @project = Project.new(:name => "Nom projet")
    @modeles = []
    (1..5).each{ |i|
      modele =    ScModel.new(:name              => "Nom modele " + i.to_s, :user_id           => 0, 
                              :project_id        => 0,              :model_file_path   => "/test/modele", 
                              :image_path        => "/test/image",  :description       => "Modele de test numero " + i.to_s, 
                              :dimension         => 3,              :ddl_number        => 3, :parts             => 3, 
                              :interfaces        => 3,              :used_space        => 3, :state             => "none")
      modele.project = @project
      @modeles << modele
    }
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @modeles.to_json}
    end
    
    # respond_to do |format|
    #   format.html { render :action => "vue_a_afficher", :layout => false }
    #   format.xml  { render :xml => @objet_a_renvoyer   }
    # end
    
  end
  
  def create
    num_model = 1
    File.open("#{RAILS_ROOT}/public/test/model_#{num_model}", 'w+') do |f|
        f.write(params.to_json)
    end
    render :json => { :result => 'success' }
  end
  
  def upload
    file = params[:Filedata]
    if file.size > 0
      File.open("#{RAILS_ROOT}/public/test/#{file.original_filename}", 'w+') do |f|
        f.write(file.read)
      end
    end
    render :json => { :result => 'success' }
    #render :text => "téléchergement ok"
  end

  
  
end
