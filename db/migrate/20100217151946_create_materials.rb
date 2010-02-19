class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
	  t.string   :name
      t.integer  :user_id
      t.integer  :project_id
      t.integer  :reference
	  t.integer  :id_select
      t.string   :name_select
      t.text     :description
	  t.string   :mtype                      # type de materiaux : isotrope, orthotrope
	  t.string   :comp                      # mot cle : el, pl, en, vi  (elastique, plastique, endomageable, visqueux)
	  t.integer  :type_num					# reference du type de materiaux, tous les materiaux de ce type on les meme champs de proprietes
	  t.float    :dir_1_x					# composante des direction principales
	  t.float    :dir_2_x
	  t.float    :dir_3_x
	  t.float    :dir_1_y
	  t.float    :dir_2_y
	  t.float    :dir_3_y
	  t.float    :dir_1_z
	  t.float    :dir_2_z
	  t.float    :dir_3_z
	  t.float    :E_1
	  t.float    :E_2
	  t.float    :E_3
	  t.float    :cis_1
	  t.float    :cis_2
	  t.float    :cis_3
	  t.float    :mu_12
	  t.float    :mu_23
	  t.float    :mu_31
	  t.float    :alpha_1
	  t.float    :alpha_2
	  t.float    :alpha_3
	  t.float    :rho
	  t.float    :sigma_p_1					# limite de plasticite dans les trois directions
	  t.float    :sigma_p_2
	  t.float    :sigma_p_3
	  t.float    :sigma_r_1					# limite de rupture dans les trois directions
	  t.float    :sigma_r_2
	  t.float    :sigma_r_3
	  t.float    :sigma_e_1					# limite d'endomagement dans les trois directions
	  t.float    :sigma_e_2
	  t.float    :sigma_e_3
	  t.float    :dp_1						# pente de plasticité
	  t.float    :dp_2
	  t.float    :dp_3
	  t.float    :p_1						# deformation plastique
	  t.float    :p_2
	  t.float    :p_3
	  t.float    :ed_1						# coefficient d'endomagement
	  t.float    :ed_2
	  t.float    :ed_3

      t.timestamps
    end
  end

  def self.down
    drop_table :materials
  end
end
