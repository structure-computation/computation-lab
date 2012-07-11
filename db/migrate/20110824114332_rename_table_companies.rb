class RenameTableCompanies < ActiveRecord::Migration
  def self.up
    rename_table :companies, :workspaces 
  end

  def self.down
    rename_table :workspaces, :companies
  end
end