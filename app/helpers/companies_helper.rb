module CompaniesHelper
  def tab_content_selected(tab_name, param, default_tab = false)
    if default_tab && param.nil?
      selected = 'show'
    else
      selected = (tab_name == param ? "show" : "hide")
    end
  end
  
  def tab_selected(tab_name, param, default_tab = false)
    if default_tab && param.nil?
      selected = 'selected'
    else
      selected = (tab_name == param ? "selected" : "")
    end
  end
end
