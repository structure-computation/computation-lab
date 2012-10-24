# encoding: utf-8

class UserScAdmin < ActiveRecord::Base
  
  belongs_to  :sc_admin
  belongs_to  :user
  has_many    :workspaces
  
end
