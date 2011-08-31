class RenameColumnCompanyId < ActiveRecord::Migration
  def self.up
        rename_column :materials, :company_id, :workspace_id
        rename_column :links, :company_id, :workspace_id
        rename_column :sc_models, :company_id, :workspace_id
	    rename_column :memory_accounts, :company_id, :workspace_id
  end

  def self.down
  end
end
