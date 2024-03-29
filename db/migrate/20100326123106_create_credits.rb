class CreateCredits < ActiveRecord::Migration
  def self.up
    create_table :credits do |t|
      t.integer :calcul_account_id
      t.integer :forfait_id
      t.integer :nb_jetons
      t.integer :nb_jetons_tempon
      t.integer :price
      t.date :credit_date
      
      t.timestamps
    end
  end

  def self.down
    drop_table :credits
  end
end
