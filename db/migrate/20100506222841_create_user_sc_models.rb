class CreateUserScModels < ActiveRecord::Migration
  def self.up
    create_table :user_sc_models do |t|

  t.integer :user_id
  t.integer :sc_model_id
  t.integer :owner, :limit => 1

    add_index "user_sc_models", ["user_id"    ], :name => "fk_user_to_scmodels"
    add_index "user_sc_models", ["sc_model_id"], :name => "fk_scmodels_to_user"

      t.timestamps
    end
  end

  def self.down
    drop_table :user_sc_models
  end
end
