class CreateLogAbonnements < ActiveRecord::Migration
  def self.up
    create_table :log_abonnements do |t|
      t.integer :memory_account_id
      t.integer :abonnement_id
      t.integer :assigned_memory
      t.integer :price
      t.date :abonnement_date
      
      t.timestamps
    end
  end

  def self.down
    drop_table :log_abonnements
  end
end
