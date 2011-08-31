class RenameColumnWorkspaceRelationships < ActiveRecord::Migration
  def self.up
    rename_column :workspace_relationships, :workspace1_id, :workspace_id
	rename_column :workspace_relationships, :workspace2_id, :related_workspace_id

  end

  def self.down
  end
end
