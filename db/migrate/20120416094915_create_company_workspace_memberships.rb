class CreateCompanyWorkspaceMemberships < ActiveRecord::Migration
  def self.up
    create_table :company_workspace_memberships do |t|
      t.integer :workspace_id
      t.integer :company_id
      t.string  :rights
      t.string  :status
      t.string  :role
      t.timestamps
    end
  end

  def self.down
    drop_table :company_workspace_memberships
  end
end
