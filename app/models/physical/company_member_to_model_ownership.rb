class CompanyMemberToModelOwnership < ActiveRecord::Base
  belongs_to  :company_member, :class_name => "UserCompanyMembership", :foreign_key => "company_member_id"
  belongs_to  :sc_model # TODO: spécifier un chargement automatique (:includes => true ?)
end
