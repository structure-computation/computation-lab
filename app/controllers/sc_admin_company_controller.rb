class ScAdminCompanyController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'workspace'
  
  def index 
    @page = 'SCadmin'
    @companies = Company.all
  end
  
  def create
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
