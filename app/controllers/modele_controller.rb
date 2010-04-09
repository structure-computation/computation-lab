# This controller handles the login/logout function of the site.  
class ModeleController < ApplicationController
  #session :cookie_only => false, :only => :upload
  require 'socket'
  include Socket::Constants
  
  def index
    @page = 'SCcompute'
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
    File.open("#{RAILS_ROOT}/public/test/test_post_create_#{num_model}", 'w+') do |f|
        f.write(params[:json])
    end
    render :text => { :result => 'success' }
  end

  def send_info
    num_model = 1
    file = params[:fichier]
    
    # création des elements a envoyer au calculateur
    identite_calcul = { :id_societe => 1, :id_user => 1, :id_projet => 1, :id_model => 1, :id_calcul => 1, :dimension => params[:dimension]};
    priorite_calcul = { :priorite => 0 };
    mesh = {:mesh_directory => "MESH", :mesh_name => "mesh", :extension => ".bdf"};
    
    model_id = {:identite_calcul => identite_calcul, :priorite_calcul => priorite_calcul, :mesh => mesh}; 
    
    send_data = {:model_id => model_id, :fichier => file.read, :mode => "create"};
    
    # socket d'envoie au serveur
    socket = Socket.new( AF_INET, SOCK_STREAM, 0 )
    sockaddr = Socket.pack_sockaddr_in( 12346, 'localhost' )
    socket.connect( sockaddr )
    socket.write( send_data.to_json )
    #socket.write( file.read )
    
    # reponse du calculateur
    results = socket.read
    
    # envoie de la reponse au client
    result1 = params[:name]
    render :text => result1 
  end
  
end
