class DropTableProjects < ActiveRecord::Migration
  def self.up
  drop_table :projects
  end
  
  def self.down
  create_table :projects
  end
end
