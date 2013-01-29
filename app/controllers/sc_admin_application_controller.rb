# encoding: utf-8


class ScAdminApplicationController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  before_filter :set_page_name
  
  layout 'sc_admin'
  
  def set_page_name
    @page = :sc_admin_application
  end
  
  def index 
    @applications = Application.all
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def new
    @application = Application.new
  end
  
  def create
    @new_application = Application.create(params[:application])
    if @new_application
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                     :notice => "Nouvelle application creee."}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "L'application n'a pas ete cree."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def edit
    @application = Application.find_by_id(params[:id])
  end

  def activate
    @application = Application.find_by_id(params[:id])
    @application.activate() 
    redirect_to :action => :index, :notice => "Le status a été modifié" # TODO traduire 
  end
  
  def pause
    @application = Application.find_by_id(params[:id])
    @application.pause() 
    redirect_to :action => :index, :notice => "Le status a été modifié" # TODO traduire 
  end
  
end
