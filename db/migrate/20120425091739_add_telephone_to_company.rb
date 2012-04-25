class AddTelephoneToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :phone, :string
  end

  def self.down
    remove_column :companies, :phone
  end
end
