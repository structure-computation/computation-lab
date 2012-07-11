class Link < ActiveRecord::Base
  
  belongs_to  :workspace
  
  # TODO: On n'avait pas dit "null" pour la lib standard ?
  scope :standard, where(:state => "standard")
  scope :from_workspace , lambda { |workspace_id|
    where(:workspace_id => workspace_id)
  }

  
  def initialize(params = nil) 
    super
    self.comp_generique ||= "" 
    self.comp_complexe  ||= "" 
  end 

  
end
