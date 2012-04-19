class ScratchUserController < InheritedResources::Base  
  layout 'login'
  
  def new
    @user = User.new
  end
  
  def create
    @new_user = User.create(params[:user])
    if @new_user 
      respond_to do |format|
        format.html {redirect_to destroy_user_session_path, 
                    :notice => "Nouvel utilsateur créé. vous allez recevoir un message de confirmation"}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to destroy_user_session_path, 
                    :notice => "L'utilsateur n'a pas été créé."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def show  
    @user           = current_user
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
    render :show, :layout => 'workspace'
  end
  
  def edit  
    @user           = current_user
    render :edit, :layout => 'workspace'
  end
  
end
