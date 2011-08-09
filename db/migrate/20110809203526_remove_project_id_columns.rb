class RemoveProjectIdColumns < ActiveRecord::Migration
  def self.up
    remove_column :sc_models          , :project_id
    remove_column :boundary_conditions, :project_id
    
  end

  def self.down
  end
end
