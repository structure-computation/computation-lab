class Topic < ActiveRecord::Base             
  belongs_to :forum
  has_many :posts
  has_many :users
end
