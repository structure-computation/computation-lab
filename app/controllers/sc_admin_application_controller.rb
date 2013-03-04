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
    
    @soldes       = SoldeTokenAccount.find(:all, :order => " created_at DESC")

    @applications = Application.all
    new_apps_temps = []
    @soldes.each do |solde_i|
        find_type = false
        @applications.each do |application_i|
            if application_i.name == solde_i.solde_type
                find_type = true
                application_i.utilization_token += solde_i.used_token if solde_i.used_token?
                application_i.exploitation_token = 0
                break
            end
        end
        if !find_type
            new_application = Application.new
            new_application.name = solde_i.solde_type
            new_application.utilization_token = solde_i.used_token
            new_application.save
            @applications << new_application
        end
    end
    
    @last_applications_bill  = SoldeTokenAccount.find(:last, :conditions => {:solde_type => "admin_applications_bill"})
    @soldes_since       = SoldeTokenAccount.find(:all, :conditions => ["created_at > ? ", @last_applications_bill.created_at])

    new_apps_temps = []
    @soldes_since.each do |solde_i|
        find_type = false
        @applications.each do |application_i|
            if application_i.name == solde_i.solde_type
                application_i.exploitation_token += solde_i.used_token if solde_i.used_token?
                break
            end
        end
    end
    
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def new_applications_bill
    @last_applications_bill  = SoldeTokenAccount.find(:last, :conditions => {:solde_type => "admin_applications_bill"})
    if @last_applications_bill.created_at.to_date == Date.today.to_date
        redirect_to :action => :index, :notice => "Date de facturation déjà renouvelée aujourd'hui" # TODO traduire 
    else
        new_solde_token_account = SoldeTokenAccount.new
        new_solde_token_account.token_account_id = -1
        new_solde_token_account.log_tool_id = -1
        new_solde_token_account.credit_id = -1
        new_solde_token_account.solde_type = "admin_applications_bill"
        new_solde_token_account.save
        redirect_to :action => :index, :notice => "Date de facturation renouvelée" # TODO traduire 
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
                     :notice => "Nouvelle application creee."} # TODO traduire 
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "L'application n'a pas ete cree."} # TODO traduire 
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
