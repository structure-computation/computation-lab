class FilesScModel < ActiveRecord::Base
  
  belongs_to  :sc_model
  belongs_to  :user
  
end
