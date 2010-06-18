class CreateFilesScModels < ActiveRecord::Migration
  def self.up
    create_table :files_sc_models do |t|
      t.integer   :sc_model_id
      t.integer   :user_id
      t.datetime  :depot_date
      t.string    :name
      t.text      :description
      t.string    :state
      t.float     :size
      t.timestamps
    end
  end

  def self.down
    drop_table :files_sc_models
  end
end
