class ScAdmin < ActiveRecord::Base
  belongs_to     :workspace
  has_many       :user_sc_admins
end
