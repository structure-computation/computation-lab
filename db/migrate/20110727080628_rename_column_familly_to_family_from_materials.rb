class RenameColumnFamillyToFamilyFromMaterials < ActiveRecord::Migration
  def self.up
    rename_column :materials, :familly, :family
  end

  def self.down
    rename_column :materials, :family, :familly
  end
end
