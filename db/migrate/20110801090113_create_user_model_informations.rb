class CreateUserModelInformations < ActiveRecord::Migration
  def self.up
    create_table :user_model_informations do |t|
      t.references :user
      t.references :model
      t.string     :rights
      t.timestamps
    end
    add_index :user_model_informations, ['user_id', 'model_id']
  end

  def self.down
    drop_table :user_model_informations
  end
end
