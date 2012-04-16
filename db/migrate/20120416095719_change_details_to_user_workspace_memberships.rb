class ChangeDetailsToUserWorkspaceMemberships < ActiveRecord::Migration
  def self.up
    add_column :user_workspace_memberships, :role, :string
  end

  def self.down
    remove_column :user_workspace_memberships, :role
  end
end
