class WorkspaceApplicationOwnership < ActiveRecord::Base
  belongs_to  :application
  belongs_to  :workspace
end
