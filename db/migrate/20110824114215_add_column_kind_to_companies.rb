class AddColumnKindToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :kind, :string
  end

  def self.down
    remove_column :companies, :kind
  end
end
