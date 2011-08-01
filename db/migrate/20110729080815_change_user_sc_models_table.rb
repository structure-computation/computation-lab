class ChangeUserScModelsTable < ActiveRecord::Migration
  def self.up
    drop_table :user_sc_models
    create_table :models_users, :id => false do |t|
  	  t.integer  :user_id
  	  t.integer  :model_id
	  end
  end

  def self.down
    drop_table :models_users
    create_table :user_sc_models do |t|
  	  t.integer  :user_id
  	  t.integer  :model_id
  	  t.string   :role
	  end
  end
end
