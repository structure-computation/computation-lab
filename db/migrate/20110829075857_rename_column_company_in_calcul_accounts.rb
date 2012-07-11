class RenameColumnCompanyInCalculAccounts < ActiveRecord::Migration
  def self.up
      rename_column :calcul_accounts, :company_id, :workspace_id
  end

  def self.down
  end
end
