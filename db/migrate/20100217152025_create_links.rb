class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
	  t.string   :name
	  t.string   :familly
      t.integer  :user_id
      t.integer  :project_id
      t.integer  :reference
	  t.integer  :id_select
      t.string   :name_select
      t.text     :description
	  t.string   :comp_generique            # mots cles : pa, el, co  (parfaite, elastique, contact)
	  t.string   :comp_complexe             # mots cles : pl, ca      (plastque, cassable)
	  t.integer  :type_num					# reference du type de liaison, toutes les liaisons de ce type on les memes champs de proprietes
	  t.float    :Ep					    # epaisseur
	  t.float    :jeux
	  t.float    :R							# raideur elastique
	  t.float    :f							# coefficient de frottement
	  t.float    :Lp						# Limite de plasticité
	  t.float    :Dp						# pente de plasticité
	  t.float    :p						    # déformation plastique
	  t.float    :Lr						# limite de rupture

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
