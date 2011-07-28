class RenameFamillyToFamilyToLinks < ActiveRecord::Migration
  def self.up
    rename_column :links, :familly, :family
  end

  def self.down
    rename_column :links, :family, :familly
  end
end
