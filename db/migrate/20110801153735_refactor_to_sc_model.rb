class RefactorToScModel < ActiveRecord::Migration
  def self.up
    rename_table  :user_model_informations, :user_model_ownerships
    rename_table  :models, :sc_models

    rename_column :user_model_ownerships, :model_id, :sc_model_id
    rename_column :calcul_results, :model_id, :sc_model_id
    
  end

  def self.down
    rename_column :user_model_ownerships, :sc_model_id, :model_id
    rename_column :calcul_results, :sc_model_id, :model_id

    rename_table :user_model_ownerships, :user_model_informations
    rename_table :sc_models, :models    
  end
end
