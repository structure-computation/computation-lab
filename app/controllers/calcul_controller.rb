class CalculController < ApplicationController

  def index
    respond_to do |format|
      format.html {render :layout => false }
    end 
    # respond_to do |format|
    #   format.html { render :action => "vue_a_afficher", :layout => false }
    #   format.xml  { render :xml => @objet_a_renvoyer   }
    # end   
  end
  
  def calculs
    @calculs = []
    (1..15).each{ |i|
      calcul =    CalculResult.new(:name => "Nom calcul " + i.to_s, :sc_model_id => 0,       :user_id   => 0,
                                   :result_date  => 0,              :launch_date => 0,       :result_file_path => "/test/modele/calcul",
                                   :description  => 0,              :type        => 'test',  :state => "test",
                                   :cpu_second_used  => 0,          :gpu_second_used  => 0,  :cpu_allocated => 0,
                                   :gpu_allocated    => 0,          :estimated_calcul_time  => 0)
      @calculs << calcul
    } 
    respond_to do |format|
      format.js   {render :json => @calculs.to_json}
    end
  end
  
  def materiaux
    @materiaux = []
    (1..25).each{ |i|
      mat =    Material.new(:name => "Nom calcul " + i.to_s)                                                 
      @materiaux << mat
    }
    
    respond_to do |format|
      format.js   {render :json => @materiaux.to_json}
    end
  end
  
  def liaisons
    @liaisons = []
    (1..25).each{ |i|
      liaison =    Link.new(:name => "Nom liaison " + i.to_s)
      @liaisons << liaison
    }
    
    respond_to do |format|
      format.js   {render :json => @liaisons.to_json}
    end
  end
  
  def CLs
    @CLs = []
    @CLs[0] = BoundaryCondition.new(:ref=>'v0', :type_picto=>'poids',        :type=>'volume', :name=>'poids')
    @CLs[1] = BoundaryCondition.new(:ref=>'v1', :type_picto=>'acceleration', :type=>'volume', :name=>'effort d\'accélération')
    @CLs[2] = BoundaryCondition.new(:ref=>'v2', :type_picto=>'centrifuge',   :type=>'volume', :name=>'effort centrifuge')
	
	@CLs[3] = BoundaryCondition.new(:ref=>'e0', :type_picto=>'effort',   :type=>'effort', :name=>'force')
	@CLs[4] = BoundaryCondition.new(:ref=>'e1', :type_picto=>'effort',   :type=>'effort', :name=>'force normale')
	@CLs[5] = BoundaryCondition.new(:ref=>'e2', :type_picto=>'effort',   :type=>'effort', :name=>'pression')
	
	@CLs[6] = BoundaryCondition.new(:ref=>'d0', :type_picto=>'depl',   :type=>'depl', :name=>'déplacement nul')
	@CLs[7] = BoundaryCondition.new(:ref=>'d1', :type_picto=>'depl',   :type=>'depl', :name=>'déplacement imposé')
	@CLs[8] = BoundaryCondition.new(:ref=>'d2', :type_picto=>'depl',   :type=>'depl', :name=>'déplacement normal imposé')
	@CLs[9] = BoundaryCondition.new(:ref=>'d3', :type_picto=>'depl',   :type=>'depl', :name=>'symétrie')
	    
    respond_to do |format|
      format.js   {render :json => @CLs.to_json}
    end
  end


end
