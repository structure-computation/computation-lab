# encoding: utf-8

class CompanyWorkspaceMembership < ActiveRecord::Base
  belongs_to  :company
  belongs_to  :workspace
end
