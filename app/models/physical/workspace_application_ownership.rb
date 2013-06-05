# encoding: utf-8

class WorkspaceApplicationOwnership < ActiveRecord::Base
  belongs_to  :application
  belongs_to  :workspace
end
