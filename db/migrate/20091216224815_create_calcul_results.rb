class CreateCalculResults < ActiveRecord::Migration
  def self.up
    create_table :calcul_results do |t|
      t.integer   :sc_model_id
      t.integer   :user_id
      t.datetime  :result_date
      t.datetime  :launch_date
      t.string    :name
      t.text      :description
      t.string    :ctype
#      t.integer   :timestep              non repris : parametres du calcul.
#      t.integer   :timestep_numbers
#      t.integer   :timestep_total_time
      t.string    :state                    # Brouillon, en demande, en cours, réalisé, téléchargé(indisp pour être effacé).
      #t.integer   :cpu_second_used
      #t.integer   :gpu_second_used
      #t.integer   :cpu_allocated
      t.integer   :gpu_allocated
      t.integer   :estimated_calcul_time
      t.integer   :calcul_time

      t.timestamps
    end
  end

  def self.down
    drop_table :calcul_results
  end
end
