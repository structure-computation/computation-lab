class RenameScModelsToModels < ActiveRecord::Migration
  def self.up
    rename_table :sc_models, :models
  end

  def self.down
    rename_table :models, :sc_models
  end
end
