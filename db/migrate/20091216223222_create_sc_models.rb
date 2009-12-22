class CreateScModels < ActiveRecord::Migration
  def self.up
    create_table sc_models do |t|
      t.string   :name
      t.integer  :user_id
      t.integer  :project_id
      t.string   :model_file_path
      t.string   :image_path
      t.text     :description
      t.integer  :dimension
      t.integer  :ddl_number     # Degres de liberté
      t.integer  :parts          # nb de pièces
      t.integer  :interfaces     # nb de liaisons        
      t.integer  :used_space
      t.string   :state          # Etat du modele : En cours de tlc, téléchargé, en cours de maillage, maillé, prêt à l'emploi, fermé, pause.
      

      t.timestamps
    end
  end

  def self.down
    drop_table :sc_models
  end
end
