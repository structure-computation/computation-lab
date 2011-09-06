# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110906214809) do

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

  create_table "bills", :force => true do |t|
    t.integer  "workspace_id"
    t.integer  "credit_id"
    t.integer  "log_abonnement_id"
    t.string   "facture_type"
    t.float    "price_calcul_HT"
    t.float    "price_calcul_TVA"
    t.float    "price_calcul_TTC"
    t.float    "price_memory_HT"
    t.float    "price_memory_TVA"
    t.float    "price_memory_TTC"
    t.float    "total_price_HT"
    t.float    "total_price_TVA"
    t.float    "total_price_TTC"
    t.string   "ref"
    t.string   "statut"
    t.date     "paid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boundary_conditions", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
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
    t.integer  "workspace_id"
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
    t.boolean  "launch_autorisation",   :default => false
    t.integer  "gpu_allocated"
    t.integer  "estimated_calcul_time"
    t.integer  "calcul_time"
    t.integer  "used_memory"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workspace_member_id"
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
    t.integer  "user_sc_admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
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
    t.integer  "workspace_member_id"
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
    t.string   "family"
    t.integer  "workspace_id"
    t.integer  "reference"
    t.integer  "id_select"
    t.string   "name_select"
    t.text     "description"
    t.string   "comp_generique"
    t.string   "comp_complexe"
    t.integer  "type_num"
    t.float    "Ep"
    t.float    "jeu"
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
    t.string   "family"
    t.integer  "workspace_id"
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
    t.integer  "workspace_id"
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

  create_table "sc_admins", :force => true do |t|
    t.integer  "workspace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sc_models", :force => true do |t|
    t.string   "name"
    t.integer  "workspace_id"
    t.string   "model_file_path"
    t.string   "image_path"
    t.text     "description"
    t.integer  "dimension"
    t.integer  "sst_number"
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

  create_table "user_model_ownerships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sc_model_id"
    t.string   "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_model_ownerships", ["user_id", "sc_model_id"], :name => "index_user_model_informations_on_user_id_and_model_id"

  create_table "user_sc_admins", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sc_admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_workspace_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "workspace_id"
    t.string   "rights"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "workspace_id"
    t.string   "firstname",            :limit => 100, :default => ""
    t.string   "lastname",             :limit => 100, :default => ""
    t.string   "telephone",            :limit => 23,  :default => ""
    t.string   "email",                :limit => 100
    t.string   "role",                 :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                               :default => "passive"
    t.datetime "deleted_at"
    t.string   "encrypted_password",                  :default => "",        :null => false
    t.string   "password_salt",                       :default => "",        :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workspace_accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workspace_member_to_model_ownerships", :force => true do |t|
    t.integer  "workspace_member_id"
    t.integer  "sc_model_id"
    t.string   "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workspace_relationships", :force => true do |t|
    t.integer  "workspace_id"
    t.integer  "related_workspace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workspaces", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "zipcode"
    t.string   "country"
    t.string   "division"
    t.string   "TVA"
    t.integer  "siren"
    t.integer  "user_sc_admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

end
