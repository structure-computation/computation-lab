# encoding: utf-8

class CompanyUserMembership < ActiveRecord::Base
  belongs_to  :company
  belongs_to  :user
end
