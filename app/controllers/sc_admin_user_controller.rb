class ScAdminUserController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  
  def index 
    @page = :sc_admin_user
    @users = User.all
  end
  
  def create
    @new_user = User.create(params[:user])
    render :json => { :result => 'success' }
    if @new_user 
      respond_to do |format|
        format.html {redirect_to sc_admin_user_path(), 
                    :notice => "Nouvel utilsateur créé."}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to sc_admin_company_path(), 
                    :notice => "L'utilsateur n'a pas été créé."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def show
    @page = :sc_admin_user
    @user    = User.find_by_id(params[:id])
    if @user 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to sc_admin_user_path(), 
                    :notice => "Cet utilisateur n'existe pas ou n'est pas accessible à partir de cette page."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
end
