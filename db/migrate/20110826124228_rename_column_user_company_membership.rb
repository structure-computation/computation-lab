class RenameColumnUserCompanyMembership < ActiveRecord::Migration
  def self.up
    rename_column :user_company_memberships, :company_id, :workspace_id
  end

  def self.down
  end
end
