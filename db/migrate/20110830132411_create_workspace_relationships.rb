class CreateWorkspaceRelationships < ActiveRecord::Migration
  def self.up
    create_table :workspace_relationships do |t|
      t.integer :workspace1_id
      t.integer :workspace2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workspace_relationships
  end
end
