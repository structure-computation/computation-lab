module ApplicationHelper
  #TODO cette méthode ne fonctionne pas partout, à corriger
  def page_selected(page, page_name)
    page == page_name ? "selected" : ""
  end
end