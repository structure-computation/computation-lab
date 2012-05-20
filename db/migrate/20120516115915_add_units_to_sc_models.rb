class AddUnitsToScModels < ActiveRecord::Migration
  def self.up
    rename_column :sc_models, :original_file_name, :original_filename
    add_column :sc_models, :units, :string
  end

  def self.down
    remove_column :sc_models, :units
  end
end
