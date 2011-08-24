class AddColumnWorkspaceId2ToWorkspaceRelationship < ActiveRecord::Migration
  def self.up
    add_column :workspace_relationships, :workspace_id2, :integer
  end

  def self.down
    remove_column :workspace_relationships, :workspace_id2
  end
end
