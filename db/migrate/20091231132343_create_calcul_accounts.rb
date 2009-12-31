class CreateCalculAccounts < ActiveRecord::Migration
  def self.up
    create_table :calcul_accounts do |t|
      t.integer :company_id
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :account_type
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :calcul_accounts
  end
end
