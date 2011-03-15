class MaterialController < ApplicationController
  #session :cookie_only => false, :only => :upload
  # before_filter :login_required
  
  def index 
    @page = 'SCcompute'
    @current_company = @current_user.company
    @standard_materials = Material.find(:all,:conditions => {:company_id => -1}) # matériaux standards
    @materials = @current_company.materials.find(:all)
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @materials.to_json}
    end
  end
  
  def get_standard_material
    @page = 'SCcompute'
    @standard_materials = Material.find(:all,:conditions => {:company_id => -1}) # matériaux standards
    respond_to do |format|
      format.js   {render :json => @standard_materials.to_json}
    end
  end
  
  def get_company_material
    @page = 'SCcompute'
    @current_company = @current_user.company
    @materials = @current_company.materials.find(:all)
    respond_to do |format|
      format.js   {render :json => @materials.to_json}
    end
  end
  
  def create
    @current_company = @current_user.company
    @new_material = @current_company.materials.build(params[:material])
    @new_material.save
#     num_model = 1
#     File.open("#{RAILS_ROOT}/public/test/material_#{num_model}", 'w+') do |f|
#         f.write(params.to_json)
#     end
    render :json => { :result => 'success' }
  end
  
end
