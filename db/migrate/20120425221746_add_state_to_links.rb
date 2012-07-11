class AddStateToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :state, :string
  end

  def self.down
  end
end
