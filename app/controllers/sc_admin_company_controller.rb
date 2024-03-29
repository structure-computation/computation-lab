# encoding: utf-8

class ScAdminCompanyController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  
  def index 
    @page = :sc_admin_company
    @companies = Company.all
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def new
    @page = :sc_admin_company
    @company = Company.new
  end
  
  def create
    @page = :sc_admin_company
    @new_company = Company.create(params[:company])
    if @new_company 
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "Nouvelle société créée."}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "La société n'a pas été créée."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def show
    @page = :sc_admin_company
    @company    = Company.find_by_id(params[:id])
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
    if @company 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "Cette société n'existe pas ou n'est pas accessible à partir de cette page."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def edit
    @page = :sc_admin_company
    @company = Company.find_by_id(params[:id])
    logger.debug @company
  end
  
end
