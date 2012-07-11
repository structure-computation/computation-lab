class AddDetailsToTokenAccount < ActiveRecord::Migration
  def self.up
    add_column :token_accounts, :active_used_token_counter, :integer
    add_column :token_accounts, :active_purchased_token_counter, :integer
  end

  def self.down
    remove_column :token_accounts, :active_used_token_counter
    remove_column :token_accounts, :active_purchased_token_counter
  end
end
