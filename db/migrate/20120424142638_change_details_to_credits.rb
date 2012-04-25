class ChangeDetailsToCredits < ActiveRecord::Migration
  def self.up
    remove_column :credits, :calcul_account_id
    remove_column :credits, :nb_jetons
    remove_column :credits, :nb_jetons_tempon
    remove_column :credits, :credit_date
    
    add_column :credits, :token_account_id, :integer
    add_column :credits, :token_price, :float
    add_column :credits, :global_price, :float
    add_column :credits, :nb_token, :float
    add_column :credits, :solde_token, :float
    add_column :credits, :used_token, :float
    add_column :credits, :state, :text
    add_column :credits, :end_date, :date
  end

  
  def self.down
    remove_column :credits, :token_account_id
    remove_column :credits, :token_price
    remove_column :credits, :global_price
    remove_column :credits, :nb_token
    remove_column :credits, :solde_token  
    remove_column :credits, :used_token  
    remove_column :credits, :state  
    remove_column :credits, :end_date  
  end
end
