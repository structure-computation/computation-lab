class CreateForfaits < ActiveRecord::Migration
  def self.up
    create_table :forfaits do |t|
      t.string :name
      t.float :price
      t.float :price_jeton
      t.integer :nb_jetons
      t.integer :nb_jetons_tempon
      t.integer :validity                                # nombre de mois de validité
      t.string :state
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end

  def self.down
    drop_table :forfaits
  end
end
