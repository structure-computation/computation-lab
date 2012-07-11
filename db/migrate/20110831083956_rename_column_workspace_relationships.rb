class RenameColumnWorkspaceRelationships < ActiveRecord::Migration
  def self.up
    rename_column :workspace_relationships, :workspace_id, :workspace_id
	rename_column :workspace_relationships, :workspace_id2, :related_workspace_id

  end

  def self.down
  end
end
