class CreateTokenAccounts < ActiveRecord::Migration
  def self.up
    create_table :token_accounts do |t|
      t.integer :workspace_id
      t.string  :status
      t.integer :used_token_counter             #compteur de jetons utilisés depuis le début
      t.integer :purchased_token_counter        #compteur de jetons achetés depuis le début
      t.integer :reserved_token                 #compteur de jetons achetés depuis le début
      t.integer :solde_token                    #solde de jetons
      t.timestamps
    end
  end

  def self.down
    drop_table :token_accounts
  end
end
