# encoding: utf-8

# Controller fait pour tester la mise en page lors de la refonte.
class StaticController < ApplicationController
  def index
    @page = :home # Pour afficher le menu en selected.
  end
  
end
