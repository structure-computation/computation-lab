class MakeDbMultiTenant < ActiveRecord::Migration
  def self.up
    
    create_table :company_member_to_model_ownerships do |t|
      t.integer  :company_member_id
      t.integer  :sc_model_id
      t.string   :rights
      
      t.timestamps
    end
    
    add_column :calcul_results , :company_member_id, :integer 
    add_column :files_sc_models, :company_member_id, :integer
    
    # Pour l'instant chaque user n'a qu'une seule "company"
    User.all.each do |user|
      ucm = UserCompanyMembership.new(:user => user, :company => user.company
                                #TODO: gérer les droits.
                                )
      ucm.save!


      # Gestion de l'appartenance des modèles. On tranfert tous les modèles appartenant à un utilisateur vers son objet membre.
      user.sc_models.each do |sc_model|
        CompanyMemberToModelOwnership.create(:company_member_id => ucm.id, :sc_model_id =>sc_model.id) #TODO: droits.
      end

      # Transfert des résultats de calcul de l'utilisateur vers le membre.
      user.calcul_results.each do |calc_result|
        calc_result.company_member_id = ucm.id
        calc_result.save
      end
      
      FilesScModel.connection.execute "UPDATE `files_sc_models` SET `company_member_id` = '#{ucm.id}' WHERE `user_id` = #{user.id}"
    
      

      # On attache les modèles à cet UCM pour :
      # - NON user_projects
      # - NON user_tasks
      # user_sc_admins
      
    end
    
  end

  def self.down
    # On ne souhaite pas renverser cette migration.
    raise ActiveRecord::IrreversibleMigration
    
  end
end
