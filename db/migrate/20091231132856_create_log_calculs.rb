class CreateLogCalculs < ActiveRecord::Migration
  def self.up
    create_table :log_calculs do |t|
      t.integer :sc_model_id
      t.integer :user_id
      t.integer :calcul_result_id
      t.integer :calcul_account_id
      t.integer :project_id
      t.integer :calcul_time
      t.integer :gpu_cards_number
      t.date :start_date
      t.date :end_date
      t.string :log_type
      t.integer :en_forfait
      t.integer :hors_forfait

      t.timestamps
    end
  end

  def self.down
    drop_table :log_calculs
  end
end
