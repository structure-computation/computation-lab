# encoding: utf-8

class WorkspaceMemberToModelOwnership < ActiveRecord::Base
  belongs_to  :workspace_member, :class_name => "UserWorkspaceMembership", :foreign_key => "workspace_member_id"
  belongs_to  :sc_model # TODO: spécifier un chargement automatique (:includes => true ?)   
  
  #On ajoute un membre de l'espace de travail et on lui donne les droits de lire ce modèle
  def addWorkspaceMemberToModelOwnership 
    @member_to_add = UserWorkspaceMembership.find_by_id([:id])
    @sc_model = ScModel.find(params[:id])
    @sc_model.workspace_members << @member_to_add #(:rights => "readonly") 
    flash[:notice] = 'Sc_model was shared.'     
  end   
            
end
