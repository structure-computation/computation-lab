class CreateUserCompanyMemberships < ActiveRecord::Migration
  def self.up
    create_table :user_company_memberships do |t|
      t.integer :user_id
      t.integer :company_id
      t.string  :rights
      t.string  :status

      t.timestamps
    end
  end

  def self.down
    drop_table :user_company_memberships
  end
end


