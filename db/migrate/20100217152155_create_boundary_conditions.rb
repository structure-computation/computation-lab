class CreateBoundaryConditions < ActiveRecord::Migration
  def self.up
    create_table :boundary_conditions do |t|
	  t.string   :name
      t.integer  :user_id
      t.integer  :project_id
      t.integer  :ref
	  t.integer  :id_select
      t.string   :name_select
      t.text     :description
	  t.string   :bctype						# volume, effort ou depl
	  t.string   :type_picto				# pour la visualisation du bon picto sur l'interface (poids, acceleration, centrifuge, effort ou depl)
	 
      t.timestamps
    end
  end

  def self.down
    drop_table :boundary_conditions
  end
end
