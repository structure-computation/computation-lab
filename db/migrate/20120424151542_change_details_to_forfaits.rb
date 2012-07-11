class ChangeDetailsToForfaits < ActiveRecord::Migration
  def self.up
    remove_column :forfaits, :price
    remove_column :forfaits, :price_jeton
    remove_column :forfaits, :nb_jetons
    remove_column :forfaits, :nb_jetons_tempon
    
    add_column :forfaits, :token_price, :float
    add_column :forfaits, :global_price, :float
    add_column :forfaits, :nb_token, :float
    
    Forfait.all.each do |cred|
      cred.destroy
    end
    Forfait.create({:name => "forfait 100", :nb_token => 100, :token_price => 2.5, :global_price => 250, :validity => 12, :state => "active"})
    Forfait.create({:name => "forfait 500", :nb_token => 500, :token_price => 2.2, :global_price => 1100, :validity => 12, :state => "active"})
    Forfait.create({:name => "forfait 1000", :nb_token => 1000, :token_price => 2, :global_price => 2000, :validity => 12, :state => "active"})
    Forfait.create({:name => "forfait 5000", :nb_token => 5000, :token_price => 1.9, :global_price => 9500, :validity => 12, :state => "active"})
    Forfait.create({:name => "forfait 10000", :nb_token => 10000, :token_price => 1.8, :global_price => 18000, :validity => 12, :state => "active"})
    Forfait.create({:name => "forfait 50000", :nb_token => 50000, :token_price => 1.7, :global_price => 85000, :validity => 12, :state => "active"})
  end

  
  def self.down
    remove_column :forfaits, :token_account_id
    remove_column :forfaits, :token_price
    remove_column :forfaits, :global_price
    remove_column :forfaits, :nb_token
    remove_column :forfaits, :solde_token  
    remove_column :forfaits, :used_token  
    remove_column :forfaits, :state  
    remove_column :forfaits, :end_date  
  end
end
