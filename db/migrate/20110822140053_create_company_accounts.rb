class CreateCompanyAccounts < ActiveRecord::Migration
  def self.up
    create_table :company_accounts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :company_accounts
  end
end
