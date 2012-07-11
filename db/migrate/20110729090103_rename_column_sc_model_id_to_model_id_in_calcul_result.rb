class RenameColumnScModelIdToModelIdInCalculResult < ActiveRecord::Migration
  def self.up
    rename_column :calcul_results, :sc_model_id, :model_id
  end

  def self.down
    rename_column :calcul_results, :model_id, :sc_model_id
  end
end
