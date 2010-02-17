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
  
  def initialisation
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
      mat =    CalculResult.new(:name => "Nom materiaux " + i.to_s, :sc_model_id => 0,       :user_id   => 0,
                                   :result_date  => 0,              :launch_date => 0,       :result_file_path => "/test/modele/calcul",
                                   :description  => 0,              :type        => 'test',  :state => "test",
                                   :cpu_second_used  => 0,          :gpu_second_used  => 0,  :cpu_allocated => 0,
                                   :gpu_allocated    => 0,          :estimated_calcul_time  => 0)
      @materiaux << mat
    }
    
    respond_to do |format|
      format.js   {render :json => @materiaux.to_json}
    end
  end
  
  def liaisons
    @liaisons = []
    (1..25).each{ |i|
      liaison =    CalculResult.new(:name => "Nom liaison " + i.to_s, :sc_model_id => 0,       :user_id   => 0,
                                   :result_date  => 0,              :launch_date => 0,       :result_file_path => "/test/modele/calcul",
                                   :description  => 0,              :type        => 'test',  :state => "test",
                                   :cpu_second_used  => 0,          :gpu_second_used  => 0,  :cpu_allocated => 0,
                                   :gpu_allocated    => 0,          :estimated_calcul_time  => 0)
      @liaisons << liaison
    }
    
    respond_to do |format|
      format.js   {render :json => @liaisons.to_json}
    end
  end

end
