class CreateScAdmins < ActiveRecord::Migration
  def self.up
    create_table :sc_admins do |t|
      
      t.integer :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sc_admins
  end
end
