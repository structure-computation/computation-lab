class RenameJeuxToJeuToLinks < ActiveRecord::Migration
  def self.up
    rename_column :links, :jeux, :jeu
  end

  def self.down
    rename_column :links, :jeu, :jeux
  end
end
