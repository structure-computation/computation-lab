class CreateCalculAccounts < ActiveRecord::Migration
  def self.up
    create_table :calcul_accounts do |t|
      t.integer :company_id
      t.date :start_date
      t.date :end_date
      t.string :status
      t.integer :report_jeton			#report de jeton du dernier forfait = solde_jeton + solde_jeton_tempon du dernier forfait
      t.integer :base_jeton			#nb de jetons de base du dernier forfait acheté
      t.integer :base_jeton_tempon		#nb de jetons tempons du dernier forfait acheté
      t.integer :solde_jeton			#solde total de jetons
      t.integer :solde_jeton_tempon		#solde total de jetons tempons
      t.integer :used_jeton			#jetons utilisés depuis la derniere recharge
      t.integer :used_jeton_tempon		#jetons tempons utilisés depuis la derniere recharge
      t.timestamps
    end
  end

  def self.down
    drop_table :calcul_accounts
  end
end
