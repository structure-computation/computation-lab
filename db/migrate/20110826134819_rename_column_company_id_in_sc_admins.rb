class RenameColumnCompanyIdInScAdmins < ActiveRecord::Migration
  def self.up
	rename_column :sc_admins, :company_id, :workspace_id
  end

  def self.down
  end
end
