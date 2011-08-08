class UserModelOwnership < ActiveRecord::Base

  belongs_to :user
  belongs_to :sc_model
  # belongs_to :user_company_membership
end
