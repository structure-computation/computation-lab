class AddLogToolIdToSoldeTokenAccount < ActiveRecord::Migration
  def self.up
    rename_column :solde_token_accounts, :calcul_result_id, :log_tool_id
  end

  def self.down
  end
end
