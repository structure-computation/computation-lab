class LinkController < ApplicationController
  #session :cookie_only => false, :only => :upload
  before_filter :authenticate_user!
  
  def index 
    @page = 'SCcompute'
    
    @current_company = current_user.company
    @standard_links = Link.find(:all,:conditions => {:company_id => -1}) # matériaux standards
    @links = @current_company.links.find(:all)
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @standard_links.to_json}
    end
  end
  
  def create
    @current_company = current_user.company
    @new_link = @current_company.links.build(params[:link])
    @new_link.save
#     num_model = 1
#     File.open("#{RAILS_ROOT}/public/test/link_#{num_model}", 'w+') do |f|
#         f.write(params.to_json)
#     end
    render :json => { :result => 'success' }
  end
end
