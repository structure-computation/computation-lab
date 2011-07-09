class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :project_id
      t.integer :created_by
      t.integer :attributed_to
      t.string :name
      t.text :description
      t.date :due_date
      t.string :state
      t.integer :estimated_done

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
