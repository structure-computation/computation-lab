class CreateWorkspaceRelationships < ActiveRecord::Migration
  def self.up
    create_table :workspace_relationships do |t|
      t.integer :workspace_id
      t.integer :workspace_id
      t.timestamps
    end
    add_index :workspace_relationships, ['workspace_id', 'workspace_id2']
  end

  def self.down
    drop_table :workspace_relationships
  end
end
                    