module ApplicationHelper
  # TODO cette méthode ne fonctionne pas partout, à corriger
  def page_selected(page, page_name)
    page == page_name ? "selected" : ""
  end
  
  # TODO: fait doublon avec la même procédure dans ApplicationController. 
  # Trouver la "bonne methode".
  def current_company_member
    current_user.user_workspace_memberships.first
  end
  
  def is_mobile?
		return /(\b(iphone|ipod|ipad|android)\b)|(W3C-mobile)/i.match(request.env["HTTP_USER_AGENT"])
	end
	
	def custom_text_field(object, var, string, disabled = false)
    if is_mobile?
      return text_field object, var, :disabled => disabled, :size => '10', :type => "number", :placeholder => string.html_safe if disabled
      return text_field object, var, :size => '10', :type => "number", :placeholder => string.html_safe
    else
      return text_field object, var, :disabled => disabled, :size => '10', :placeholder => string.html_safe if disabled
      return text_field object, var, :size => '10', :placeholder => string.html_safe
    end
	end
end