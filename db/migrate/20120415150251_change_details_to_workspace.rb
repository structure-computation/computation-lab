class ChangeDetailsToWorkspace < ActiveRecord::Migration
  def self.up
    remove_column :workspaces, :address
    remove_column :workspaces, :city
    remove_column :workspaces, :zipcode
    remove_column :workspaces, :country
    remove_column :workspaces, :division
    remove_column :workspaces, :TVA
    remove_column :workspaces, :siren
    remove_column :workspaces, :user_sc_admin_id
    
    add_column :workspaces, :public_description, :string
    add_column :workspaces, :private_description, :string
    add_column :workspaces, :state, :string
    
    Company.all.each do |comp|
      comp.public_description = "cette description est publique"
      comp.private_description = "cette description est privée"
      comp.state = "public"
    end
  end

  def self.down
  end
end
