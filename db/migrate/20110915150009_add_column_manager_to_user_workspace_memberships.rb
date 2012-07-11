class AddColumnManagerToUserWorkspaceMemberships < ActiveRecord::Migration
  def self.up
    add_column :user_workspace_memberships, :manager, :boolean
  end

  def self.down
    remove_column :user_workspace_memberships, :manager
  end
end
