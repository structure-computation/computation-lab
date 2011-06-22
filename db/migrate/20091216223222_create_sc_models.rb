class CreateScModels < ActiveRecord::Migration
  def self.up
    create_table :sc_models do |t|
      t.string   :name
      t.integer  :company_id
      t.integer  :project_id
      t.string   :model_file_path
      t.string   :image_path
      t.text     :description
      t.integer  :dimension
      t.integer  :sst_number     # nombre d'element (= sst) du model
      t.integer  :parts          # nb de pièces
      t.integer  :interfaces     # nb de liaisons        
      t.integer  :used_memory
      t.string   :state          # Etat du modele : void, in_process, active, deleted, 
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sc_models
  end
end
