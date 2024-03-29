class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :zipcode
      t.string :country
      t.string :division
      t.string :TVA
      t.integer :siren
      t.integer :user_sc_admin_id

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
