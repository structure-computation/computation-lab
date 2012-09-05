class ChangeDetailsToLinks < ActiveRecord::Migration
  def self.up
    remove_column :links        , :jeu
    remove_column :links        , :Ep
    remove_column :links        , :Lp
    remove_column :links        , :Dp
    remove_column :links        , :p
    remove_column :links        , :Lr
    remove_column :links        , :R
    
    add_column    :links        , :Preload_n    , :float               #précharge normale
    add_column    :links        , :Preload_x    , :float               #précharge x
    add_column    :links        , :Preload_y    , :float               #précharge y
    add_column    :links        , :Preload_z    , :float               #précharge z
    
    add_column    :links        , :Ep_n         , :float               #épaisseur normale imposée
    add_column    :links        , :Ep_x         , :float               #épaisseur imposée x
    add_column    :links        , :Ep_y         , :float               #épaisseur imposée y
    add_column    :links        , :Ep_z         , :float               #épaisseur imposée z
    
    add_column    :links        , :Kn           , :float               #raideur normale en traction
    add_column    :links        , :Knc          , :float               #raideur normale en compression
    add_column    :links        , :Kt           , :float               #raideur tangenielle
    
    add_column    :links        , :gamma        , :float               #paramètre cohésif coeff de couplage f normal et tangentiel 
    add_column    :links        , :alpha        , :float               #paramètre cohésif coeff de d'ordre de la norme f normal et tangentiel 
    add_column    :links        , :n            , :float               #
    add_column    :links        , :Yc           , :float               #énergie critique d'endomagement
    add_column    :links        , :Yo           , :float               #
    
    add_column    :links        , :Fcr_n        , :float               #charge critique rupture normale
    add_column    :links        , :Fcr_t        , :float               #charge critique rupture tangentielle
    
    add_column    :links        , :Rop          , :float               #contrainte limite pour la plasticité
    add_column    :links        , :kp           , :float               #facteur de la loi d'ecrouissage
    add_column    :links        , :np           , :float               #exposant de la loi d'ecrouissage
  end

  def self.down
  end
end
