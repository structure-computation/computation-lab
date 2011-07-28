class Link < ActiveRecord::Base
  
  belongs_to  :company
  
  scope :standard, where(:company_id => -1)
  
end
