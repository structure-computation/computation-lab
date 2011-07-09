class UserScModel < ActiveRecord::Base

  belongs_to :user
  belongs_to :sc_model
end
