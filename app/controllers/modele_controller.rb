# This controller handles the login/logout function of the site.  
class ModeleController < ApplicationController
  
  def index
    # Creation d'un projet et de plusieurs SC_modeles pour tester le comportement du tableau.
    @project = Project.new(:name => "Nom projet")
    @modeles = []
    (1..15).each{ |i|
      modele =    ScModel.new(:name              => "Nom modele " + i.to_s, :user_id           => 0, 
                              :project_id        => 0,              :model_file_path   => "/test/modele", 
                              :image_path        => "/test/image",  :description       => "Modele de test numero " + i.to_s, 
                              :dimension         => 3,              :ddl_number        => 3, :parts             => 3, 
                              :interfaces        => 3,              :used_space        => 3, :state             => "none")
      modele.project = @project
      @modeles << modele
    }
    
    respond_to do |format|
      format.html
      format.js   {render :json => @modeles.to_json}
    end
    
    # respond_to do |format|
    #   format.html { render :action => "vue_a_afficher", :layout => false }
    #   format.xml  { render :xml => @objet_a_renvoyer   }
    # end
    
  end
  
  
  
  
end
