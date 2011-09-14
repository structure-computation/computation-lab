FactoryGirl.define do
  sequence :link_name do |n|
    "link_#{n}"
  end
       
  factory :link, :class => Link do 
    name "demo link" #{link_name}
    
    factory :standard_link do
      workspace_id -1
    end
    
  end
  
end


# Définition de link
# t.string   "name"
# t.string   "family"
# t.integer  "workspace_id"
# t.integer  "reference"
# t.integer  "id_select"
# t.string   "name_select"
# t.text     "description"
# t.string   "comp_generique"
# t.string   "comp_complexe"
# t.integer  "type_num"
# t.float    "Ep"
# t.float    "jeu"
# t.float    "R"
# t.float    "f"
# t.float    "Lp"
# t.float    "Dp"
# t.float    "p"
# t.float    "Lr"
# t.datetime "created_at"
# t.datetime "updated_at"