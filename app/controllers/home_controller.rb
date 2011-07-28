class HomeController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :set_page_name 
  
  def set_page_name
    @page = :accueil
  end
  
  def index  
  end

end
