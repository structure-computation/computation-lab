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

ActiveRecord::Schema.define(:version => 20100112215706) do

  create_table "calcul_accounts", :force => true do |t|
    t.integer  "company_id"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "account_type"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calcul_results", :force => true do |t|
    t.integer  "sc_model_id"
    t.integer  "user_id"
    t.datetime "result_date"
    t.datetime "launch_date"
    t.string   "result_file_path"
    t.string   "name"
    t.text     "description"
    t.string   "type"
    t.string   "state"
    t.integer  "cpu_second_used"
    t.integer  "gpu_second_used"
    t.integer  "cpu_allocated"
    t.integer  "gpu_allocated"
    t.integer  "estimated_calcul_time"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_calculs", :force => true do |t|
    t.integer  "sc_model_id"
    t.integer  "user_id"
    t.integer  "calcul_result_id"
    t.integer  "calcul_account_id"
    t.integer  "project_id"
    t.integer  "calcul_time"
    t.integer  "gpu_cards_number"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "log_type"
    t.integer  "en_forfait"
    t.integer  "hors_forfait"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memory_accounts", :force => true do |t|
    t.integer  "company_id"
    t.text     "description"
    t.date     "inscription_date"
    t.date     "end_date"
    t.string   "type"
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
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "model_file_path"
    t.string   "image_path"
    t.text     "description"
    t.integer  "dimension"
    t.integer  "ddl_number"
    t.integer  "parts"
    t.integer  "interfaces"
    t.integer  "used_space"
    t.string   "state"
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
