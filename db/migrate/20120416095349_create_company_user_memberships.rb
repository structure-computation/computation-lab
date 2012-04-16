class CreateCompanyUserMemberships < ActiveRecord::Migration
  def self.up
    create_table :company_user_memberships do |t|
      t.integer :user_id
      t.integer :company_id
      t.string  :rights
      t.string  :status
      t.string  :role
      t.timestamps
    end
  end

  def self.down
    drop_table :company_user_memberships
  end
end
