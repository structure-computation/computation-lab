class CompanyWorkspaceMembership < ActiveRecord::Base
  belongs_to  :company
  belongs_to  :workspace
end
