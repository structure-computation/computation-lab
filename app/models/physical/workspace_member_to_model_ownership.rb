class WorkspaceMemberToModelOwnership < ActiveRecord::Base
  belongs_to  :workspace_member, :class_name => "UserWorkspaceMembership", :foreign_key => "workspace_member_id"
  belongs_to  :sc_model # TODO: spécifier un chargement automatique (:includes => true ?)   
  
  def add
       @member = UserWorkspaceMembership.find(session[:user_id])
       @sc_model = ScModel.find(params[:id])
       @member.sc_models << @sc_model
       flash[:notice] = 'Sc_model was saved.'
   end
  
end
