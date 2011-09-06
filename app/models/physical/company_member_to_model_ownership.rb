class WorkspaceMemberToModelOwnership < ActiveRecord::Base
  belongs_to  :workspace_member, :class_name => "UserWorkspaceMembership", :foreign_key => "workspace_member_id"
  belongs_to  :sc_model # TODO: spécifier un chargement automatique (:includes => true ?)
end
