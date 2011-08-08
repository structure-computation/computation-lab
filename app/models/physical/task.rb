class Task < ActiveRecord::Base
  has_many :user_tasks
  has_many :user, :through => :user_tasts
end
