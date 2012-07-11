class AddColumnPreferenceToUserWorkspaceMemberships < ActiveRecord::Migration
  def self.up
   add_column :user_workspace_memberships, :preference, :string
  end

  def self.down
     remove_column :user_workspace_memberships, :preference
  end
end
