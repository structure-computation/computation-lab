# Controller fait pour tester la mise en page lors de la refonte.
class StaticController < ApplicationController
  layout "application2"
  def index
    @page = :home # Pour afficher le menu en selected.
  end
  
end
