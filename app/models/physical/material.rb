class Material < ActiveRecord::Base
  
  belongs_to  :company
  
  scope :standard     , where(:company_id => -1)
  # TODO: Idem commentaire sur les liens. on pourrait appeller ce scope (from_workspace)
  scope :user_company , lambda { |company_id|
    where(:company_id => company_id)
  }

  def initialize(params = nil) 
    super
    self.comp ||= "" 
  end 

end
