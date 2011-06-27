class CreateUserScAdmins < ActiveRecord::Migration
  def self.up
    create_table :user_sc_admins do |t|
      t.integer :user_id
      t.integer :sc_admin_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_sc_admins
  end
end
