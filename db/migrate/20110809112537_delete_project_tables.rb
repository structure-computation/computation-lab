class DeleteProjectTables < ActiveRecord::Migration
  def self.up
    drop_table :projects
    drop_table :user_projects
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
