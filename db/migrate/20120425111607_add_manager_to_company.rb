class AddManagerToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :firstname, :string
    add_column :companies, :lastname, :string
  end

  def self.down
    remove_column :companies, :firstname
    remove_column :companies, :lastname
  end
end
