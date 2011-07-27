class MaterialsController < ApplicationController
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  
  def index 
    @page = 'SCcompute'
    @current_company = current_user.company
    @materials = @current_company.materials.find(:all)
    @standard_materials = Material.standard
    if params[:type] == "standard"
      @standard_materials = @materials
    end
    respond_to do |format|
      format.html #{render :layout => true }
      if params[:type] == "standard"
        format.js   {render :json => @standard_materials.to_json}  # matériaux standards
      else
        format.js   {render :json => @materials.to_json}
      end
    end
  end
  
  def create
    @current_company = current_user.company
    @new_material = @current_company.materials.build(params[:material])
    @new_material.save
#     num_model = 1
#     File.open("#{RAILS_ROOT}/public/test/material_#{num_model}", 'w+') do |f|
#         f.write(params.to_json)
#     end
    render :json => { :result => 'success' }
  end

  def show
    @material = Material.find(params[:id])
		# TODO redirect according withe the type of comments
		respond_to do |format|
			format.html { redirect_to(:controller => 'users', :action => 'profile', :id => @comment.user_id) }
			format.xml { render :xml => @comment }
		end
  end
  
end
