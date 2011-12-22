class ExtAppVisuController < ApplicationController
  layout "application_ext_app"
  def index
    #@page = :home # Pour afficher le menu en selected.
    render :layout => false 
  end
end
