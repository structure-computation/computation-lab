class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.string  :name
      t.string  :description
      t.string  :powered_by
      t.string  :company_id                      # powered by this company
      t.string  :logo
      t.integer :registration_token
      t.integer :utilization_token
      t.integer :distribution_token
      t.integer :exploitation_token
      t.string  :state
      
      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
