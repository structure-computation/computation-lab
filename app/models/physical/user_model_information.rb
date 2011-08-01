class UserModelInformation < ActiveRecord::Base

  belongs_to :user
  belongs_to :model
  
end
