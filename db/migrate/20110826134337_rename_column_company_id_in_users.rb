class RenameColumnCompanyIdInUsers < ActiveRecord::Migration
  def self.up
      rename_column :users, :company_id, :workspace_id
  end

  def self.down
  end
end
