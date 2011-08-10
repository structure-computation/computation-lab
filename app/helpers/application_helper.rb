module ApplicationHelper
  #TODO cette méthode ne fonctionne pas partout, à corriger
  def page_selected(page, page_name)
    page == page_name ? "selected" : ""
  end
  
  def current_company_member
    current_user.user_company_memberships.first
  end
  
end