class ChangeDetailsToMaterials < ActiveRecord::Migration
  def self.up
    remove_column :materials, :sigma_p_1
    remove_column :materials, :sigma_p_2
    remove_column :materials, :sigma_p_3
    remove_column :materials, :sigma_r_1
    remove_column :materials, :sigma_r_2
    remove_column :materials, :sigma_r_3
    remove_column :materials, :sigma_e_1
    remove_column :materials, :sigma_e_2
    remove_column :materials, :sigma_e_3
    remove_column :materials, :H_1
    remove_column :materials, :H_2
    remove_column :materials, :H_3
    remove_column :materials, :p_1
    remove_column :materials, :p_2
    remove_column :materials, :p_3
    remove_column :materials, :ed_1
    remove_column :materials, :ed_2
    remove_column :materials, :ed_3
    
    add_column :materials, :viscosite, :float
    add_column :materials, :type_plast, :string
    add_column :materials, :k_p, :float
    add_column :materials, :m_p, :float
    add_column :materials, :R0, :float
    add_column :materials, :coeff_plast_cinematique, :float
    add_column :materials, :couplage, :float
    add_column :materials, :type_endo, :string
    add_column :materials, :Yo, :float
    add_column :materials, :Yc, :float
    add_column :materials, :Ycf, :float
    add_column :materials, :dmax, :float
    add_column :materials, :b_c, :float
    add_column :materials, :effet_retard, :float
    add_column :materials, :a, :float
    add_column :materials, :tau_c, :float
  end

  def self.down
  end
end
