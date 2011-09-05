class Link < ActiveRecord::Base
  
  belongs_to  :workspace
  
  # TODO: On n'avait pas dit "null" pour la lib standard ?
  scope :standard, where(:workspace_id => -1)
  # TODO: Renommer plus explicitement comme (from_workspace ou workspace_links ou workspace_library...)
  scope :user_company , lambda { |workspace_id|
    where(:company_id => workspace_id)
  }

  
  def initialize(params = nil) 
    super
    self.comp_generique ||= "" 
    self.comp_complexe  ||= "" 
  end 

  
end
