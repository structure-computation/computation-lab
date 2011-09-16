class AddColumnEngineerToUserWorkspaceMemberships < ActiveRecord::Migration
  def self.up
    add_column :user_workspace_memberships, :engineer, :boolean
  end

  def self.down
    remove_column :user_workspace_memberships, :engineer
  end
end
