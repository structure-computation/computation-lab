class ScAdminCompanyController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  
  def index 
    @page = :sc_admin_company
    @companies = Company.all
  end
  
  def new
    @page = :sc_admin_company
    @company = Company.new
    logger.debug @company
  end
  
  def create
    @page = :sc_admin_company
    @new_company = Company.create(params[:company])
    render :json => { :result => 'success' }
    if @new_company 
      respond_to do |format|
        format.html {redirect_to sc_admin_company_path(), 
                    :notice => "Nouvelle société créée."}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to sc_admin_company_path(), 
                    :notice => "La société n'a pas été créée."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def show
    @page = :sc_admin_company
    @company    = Company.find_by_id(params[:id])
    if @company 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to sc_admin_company_path(), 
                    :notice => "Cette société n'existe pas ou n'est pas accessible à partir de cette page."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
end
