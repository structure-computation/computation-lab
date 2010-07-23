class ScAdmin < ActiveRecord::Base
  belongs_to     :company
  has_many       :user_sc_admins
end
