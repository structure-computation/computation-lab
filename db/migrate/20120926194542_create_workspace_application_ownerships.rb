class CreateWorkspaceApplicationOwnerships < ActiveRecord::Migration
  def self.up
    create_table :workspace_application_ownerships do |t|
      t.integer :workspace_id
      t.integer :application_id
      t.date    :end_date
      t.string  :status
      t.timestamps
    end
  end

  def self.down
    drop_table :workspace_application_ownerships
  end
end
