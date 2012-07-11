class DropModelsUsers < ActiveRecord::Migration
  def self.up
    drop_table :models_users
  end

  def self.down
  end
end
