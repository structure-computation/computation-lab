class CreateMemoryAccounts < ActiveRecord::Migration
  def self.up
    create_table :memory_accounts do |t|
      t.integer :company_id
      t.text :description
      t.date :inscription_date
      t.date :end_date
      t.string :type
      t.integer :assigned_memory
      t.float :used_memory
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :memory_accounts
  end
end
