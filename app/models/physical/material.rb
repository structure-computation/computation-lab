class Material < ActiveRecord::Base
  
  belongs_to  :workspace
  
  scope :standard       , where(:state => "standard")
  scope :from_workspace , lambda { |workspace_id|
    where(:workspace_id => workspace_id)
  }

  def initialize(params = nil) 
    super
    self.comp ||= "" 
  end 

end
