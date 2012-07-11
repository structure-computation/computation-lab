class AddStateToMaterials < ActiveRecord::Migration
  def self.up
    add_column :materials, :state, :string
  end

  def self.down
  end
end
