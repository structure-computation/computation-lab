# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100617151630) do

  create_table "abonnements", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.integer  "assigned_memory"
    t.integer  "security_level"
    t.integer  "nb_max_user"
    t.string   "state"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boundary_conditions", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "ref"
    t.integer  "id_select"
    t.string   "name_select"
    t.text     "description"
    t.string   "bctype"
    t.string   "type_picto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calcul_accounts", :force => true do |t|
    t.integer  "company_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status"
    t.integer  "report_jeton"
    t.integer  "base_jeton"
    t.integer  "base_jeton_tempon"
    t.integer  "solde_jeton"
    t.integer  "solde_jeton_tempon"
    t.integer  "used_jeton"
    t.integer  "used_jeton_tempon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calcul_results", :force => true do |t|
    t.integer  "sc_model_id"
    t.integer  "user_id"
    t.datetime "result_date"
    t.datetime "launch_date"
    t.string   "name"
    t.text     "description"
    t.string   "ctype"
    t.string   "D2type"
    t.string   "log_type"
    t.string   "state"
    t.integer  "gpu_allocated"
    t.integer  "estimated_calcul_time"
    t.integer  "calcul_time"
    t.integer  "used_memory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "zipcode"
    t.string   "country"
    t.string   "division"
    t.string   "TVA"
    t.integer  "siren"
    t.integer  "admin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits", :force => true do |t|
    t.integer  "calcul_account_id"
    t.integer  "forfait_id"
    t.integer  "nb_jetons"
    t.integer  "nb_jetons_tempon"
    t.integer  "price"
    t.date     "credit_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "factures", :force => true do |t|
    t.integer  "company_id"
    t.integer  "calcul_account_id"
    t.integer  "memory_account_id"
    t.integer  "forfait_id"
    t.integer  "jetons_utilise"
    t.integer  "jetons_achete"
    t.float    "total_calcul"
    t.float    "total_memory"
    t.float    "total"
    t.integer  "facture_month"
    t.integer  "facture_year"
    t.date     "facture_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "files_sc_models", :force => true do |t|
    t.integer  "sc_model_id"
    t.integer  "user_id"
    t.datetime "depot_date"
    t.string   "name"
    t.text     "description"
    t.string   "state"
    t.float    "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forfaits", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.float    "price_jeton"
    t.integer  "nb_jetons"
    t.integer  "nb_jetons_tempon"
    t.integer  "validity"
    t.string   "state"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "name"
    t.string   "familly"
    t.integer  "company_id"
    t.integer  "reference"
    t.integer  "id_select"
    t.string   "name_select"
    t.text     "description"
    t.string   "comp_generique"
    t.string   "comp_complexe"
    t.integer  "type_num"
    t.float    "Ep"
    t.float    "jeux"
    t.float    "R"
    t.float    "f"
    t.float    "Lp"
    t.float    "Dp"
    t.float    "p"
    t.float    "Lr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_abonnements", :force => true do |t|
    t.integer  "memory_account_id"
    t.integer  "abonnement_id"
    t.integer  "assigned_memory"
    t.integer  "price"
    t.date     "abonnement_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_calculs", :force => true do |t|
    t.integer  "calcul_result_id"
    t.integer  "calcul_account_id"
    t.integer  "calcul_time"
    t.integer  "gpu_cards_number"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "log_type"
    t.integer  "debit_jeton"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materials", :force => true do |t|
    t.string   "name"
    t.string   "familly"
    t.integer  "company_id"
    t.integer  "reference"
    t.integer  "id_select"
    t.string   "name_select"
    t.text     "description"
    t.string   "mtype"
    t.string   "comp"
    t.integer  "type_num"
    t.float    "dir_1_x"
    t.float    "dir_2_x"
    t.float    "dir_3_x"
    t.float    "dir_1_y"
    t.float    "dir_2_y"
    t.float    "dir_3_y"
    t.float    "dir_1_z"
    t.float    "dir_2_z"
    t.float    "dir_3_z"
    t.float    "E_1"
    t.float    "E_2"
    t.float    "E_3"
    t.float    "cis_1"
    t.float    "cis_2"
    t.float    "cis_3"
    t.float    "nu_12"
    t.float    "nu_23"
    t.float    "nu_13"
    t.float    "alpha_1"
    t.float    "alpha_2"
    t.float    "alpha_3"
    t.float    "rho"
    t.float    "sigma_p_1"
    t.float    "sigma_p_2"
    t.float    "sigma_p_3"
    t.float    "sigma_r_1"
    t.float    "sigma_r_2"
    t.float    "sigma_r_3"
    t.float    "sigma_e_1"
    t.float    "sigma_e_2"
    t.float    "sigma_e_3"
    t.float    "H_1"
    t.float    "H_2"
    t.float    "H_3"
    t.float    "p_1"
    t.float    "p_2"
    t.float    "p_3"
    t.float    "ed_1"
    t.float    "ed_2"
    t.float    "ed_3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memory_accounts", :force => true do |t|
    t.integer  "company_id"
    t.text     "description"
    t.date     "inscription_date"
    t.date     "end_date"
    t.string   "type"
    t.integer  "assigned_memory"
    t.float    "used_memory"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "estimated_end_date"
    t.date     "end_date"
    t.integer  "estimated_done"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sc_models", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.integer  "project_id"
    t.string   "model_file_path"
    t.string   "image_path"
    t.text     "description"
    t.integer  "dimension"
    t.integer  "ddl_number"
    t.integer  "parts"
    t.integer  "interfaces"
    t.integer  "used_memory"
    t.string   "state"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solde_calcul_accounts", :force => true do |t|
    t.integer  "calcul_account_id"
    t.integer  "log_calcul_id"
    t.integer  "credit_id"
    t.string   "solde_type"
    t.integer  "credit_jeton"
    t.integer  "credit_jeton_tempon"
    t.integer  "debit_jeton"
    t.integer  "debit_jeton_tempon"
    t.integer  "solde_jeton"
    t.integer  "solde_jeton_tempon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "project_id"
    t.integer  "created_by"
    t.integer  "attributed_to"
    t.string   "name"
    t.text     "description"
    t.date     "due_date"
    t.string   "state"
    t.integer  "estimated_done"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_projects", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sc_models", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sc_model_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_tasks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.integer  "is_creator"
    t.integer  "is_assigned_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "company_id"
    t.string   "firstname",                 :limit => 100, :default => ""
    t.string   "lastname",                  :limit => 100, :default => ""
    t.string   "telephone",                 :limit => 23,  :default => ""
    t.string   "email",                     :limit => 100
    t.string   "role",                      :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
