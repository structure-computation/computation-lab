class AddAncestryToForum < ActiveRecord::Migration
  def self.up  
    add_column :forums, :ancestry, :string  
    add_index :forums, :ancestry  
  end  
  
  def self.down  
    remove_index :forums, :ancestry  
    remove_column :forums, :ancestry  
  end
end
