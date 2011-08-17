class Link < ActiveRecord::Base
  
  belongs_to  :company
  
  scope :standard, where(:company_id => -1)
  
  def initialize(params = nil) 
    super
    self.comp_generique ||= "" 
    self.comp_complexe  ||= "" 
  end 

  
end
