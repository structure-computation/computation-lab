module ApplicationHelper
  #TODO cette méthode ne fonctionne pas partout, à corriger
  def page_selected(page, page_name)
    page == page_name ? "selected" : ""
  end
  def is_mobile?
		return /(\b(iphone|ipod|ipad|android)\b)|(W3C-mobile)/i.match(request.env["HTTP_USER_AGENT"])
	end
end