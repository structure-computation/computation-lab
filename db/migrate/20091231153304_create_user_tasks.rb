class CreateUserTasks < ActiveRecord::Migration
  def self.up
    create_table :user_tasks do |t|
      t.integer :user_id
      t.integer :task_id
      
      t.integer :is_creator
      t.integer :is_assigned_to

      t.timestamps
    end
  end

  def self.down
    drop_table :user_tasks
  end
end
