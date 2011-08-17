class Material < ActiveRecord::Base
  
  belongs_to  :company
  
  scope :standard, where(:company_id => -1)

  def initialize(params = nil) 
    super
    self.comp ||= "" 
  end 

end
