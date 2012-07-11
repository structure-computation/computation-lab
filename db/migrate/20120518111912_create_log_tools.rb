class CreateLogTools < ActiveRecord::Migration
  def self.up
    create_table :log_tools do |t|
      t.integer   :sc_model_id
      t.integer   :calcul_result_id
      t.integer   :workspace_member_id
      t.integer   :token_account_id
      t.string    :log_name
      t.string    :log_type                     # scills, scult, sceen... 
      t.string    :state                        # pending, on_demand, on_process, finish, echec.
      t.boolean   :launch_autorisation   ,:default => 0 # autorisation ou non de lancer le calcul true ou false
      t.integer   :cpu_allocated
      t.integer   :nb_token
      t.integer   :estimated_time
      t.integer   :real_time
      t.timestamps
    end
  end

  def self.down
    drop_table :log_tools
  end
end
