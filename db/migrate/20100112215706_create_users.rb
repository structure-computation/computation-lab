class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      # t.column :login,                     :string, :limit => 40
      # Relations
      t.column :company_id,                      :integer
      
      t.column :firstname,                      :string, :limit => 100, :default => '', :null => true
      t.column :lastname,                       :string, :limit => 100, :default => '', :null => true
      t.column :telephone,                      :string, :limit => 23 , :default => '', :null => true # Souvenirs des normes ISUP etc, le max devait etre 15, lu 22 recemment...
      t.column :email,                     :string, :limit => 100
      
      # restfull auth
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :state,                     :string, :null => :no, :default => 'passive'
      t.column :deleted_at,                :datetime
    end
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
