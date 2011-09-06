class ChangeCompanyToWorkspaceInAllNames < ActiveRecord::Migration
  def self.up
    rename_column :calcul_results                     , :company_member_id, :workspace_member_id
    rename_column :company_member_to_model_ownerships , :company_member_id, :workspace_member_id
    rename_column :files_sc_models                    , :company_member_id, :workspace_member_id
    
    rename_table  :company_member_to_model_ownerships , :workspace_member_to_model_ownerships
    rename_table  :company_accounts                   , :workspace_accounts
    
  end
  

  def self.down
    # Les migrations reviendront à 0 après cela.
    raise ActiveRecord::IrreversibleMigration
  end
end
