class RenameUserCompanyMembershipToUserWorkspaceMembership < ActiveRecord::Migration
  def self.up
    rename_table :user_company_memberships, :user_workspace_memberships 
  end

  def self.down
    rename_table :user_workspace_memberships, :user_company_memberships 
  end
end
