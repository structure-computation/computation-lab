class RenameBillsCompanyIdToWorkspaceId < ActiveRecord::Migration
  def self.up
    rename_column :bills, :workspace_id   , :workspace_id
  end

  def self.down
    rename_column :bills, :workspace_id , :workspace_id
  end
end
