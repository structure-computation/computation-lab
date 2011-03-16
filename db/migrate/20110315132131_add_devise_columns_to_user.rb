
class AddDeviseColumnsToUser < ActiveRecord::Migration
    def self.up
    change_table :users do |t|
      
      # Suppression des colonnes de restful auth
      t.remove :crypted_password         
      t.remove :salt                     
      t.remove :remember_token        
      t.remove :remember_token_expires_at
      t.remove :activation_code
      t.remove :activated_at
      # On conserve "state" et "deleted_at" pour le moment.
      
      # if you already have a email column, you have to comment the below line and add the :encrypted_password column manually (see devise/schema.rb).
      # # t.database_authenticatable
      t.string   "encrypted_password",   :default => "", :null => false
      t.string   "password_salt",        :default => "", :null => false
            
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable
      
      
      add_index :users, :reset_password_token, :unique => true
      add_index :users, :confirmation_token,   :unique => true
      
      # On place tous les mots de passe à 'monkey'
      User.all.each do |user|
        user.password = 'monkey'
        user.save
      end
      
    end
  end
  

  def self.down
    # the columns below are manually extracted from devise/schema.rb.
    change_table :users do |t|
      t.remove :encrypted_password
      t.remove :password_salt
      # t.remove :authentication_token
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
      t.remove :reset_password_token
      t.remove :remember_token
      t.remove :remember_created_at
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
      t.remove :failed_attempts
      t.remove :unlock_token
      t.remove :locked_at
      
      t.string   "crypted_password",          :limit => 40
      t.string   "salt",                      :limit => 40
      t.string   "remember_token",            :limit => 40
      t.datetime "remember_token_expires_at"
      t.string   "activation_code",           :limit => 40
      t.datetime "activated_at"
      
      # Ne fonctionne pas.
      # remove_index :users, :reset_password_token
      # remove_index :users, :confirmation_token
      
    end
  end
end
