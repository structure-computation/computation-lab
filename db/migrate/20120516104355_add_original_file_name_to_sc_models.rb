class AddOriginalFileNameToScModels < ActiveRecord::Migration
  def self.up
    add_column :sc_models, :original_file_name, :string
  end

  def self.down
    remove_column :sc_models, :original_file_name
  end
end
