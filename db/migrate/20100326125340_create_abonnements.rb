class CreateAbonnements < ActiveRecord::Migration
  def self.up
    create_table :abonnements do |t|
      t.string :name
      t.float :price
      t.integer :Assigned_memory
      t.integer :security_level
      t.integer :nb_max_user
      t.string :state
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end

  def self.down
    drop_table :abonnements
  end
end
