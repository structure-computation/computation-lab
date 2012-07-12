module ApplicationHelper
  # TODO cette méthode ne fonctionne pas partout, à corriger
  include SCAuthenticationHelpers
  
  def page_selected(page, page_name)
    page == page_name ? "selected" : ""
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