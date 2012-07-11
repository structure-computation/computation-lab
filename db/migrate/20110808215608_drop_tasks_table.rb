class DropTasksTable < ActiveRecord::Migration
  def self.up
    drop_table :tasks
    drop_table :user_tasks
  end

  def self.down
    # On ne souhaite pas renverser cette migration.
    raise ActiveRecord::IrreversibleMigration
    
  end
end
