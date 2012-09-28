class AddApplicationIdToLogTools < ActiveRecord::Migration
  def self.up
    add_column :log_tools, :application_id, :integer
  end

  def self.down
    remove_column :log_tools, :application_id
  end
end
