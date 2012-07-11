class AddLaunchStateToLogTools < ActiveRecord::Migration
  def self.up
    add_column :log_tools, :launch_state, :string
  end

  def self.down
    remove_column :log_tools, :launch_state
  end
end
