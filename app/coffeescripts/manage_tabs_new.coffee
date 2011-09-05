# @params tabsHash : 
#     "id_tab1" : "content_associated1"
#     "id_tab2" : "content_associated2"
# Add an onClick handler on each tab for hiding other tab content.
# The first tab/content will be selectionned and shown at first
window.manage_tabs = (tabsHash) ->  
  first = true
  for tab of tabsHash
    # Select first tab and hide others
    if first
      first = false
      $(tabsHash[tab]).show()
      $(tab).addClass "selected"
    else
      $(tabsHash[tab]).hide()

    # Add on click handler
    $(tab).click ->
      # Hide all tab contents
      for tabID of tabsHash
        $(tabsHash[tabID]).hide()
        $(tabID).removeClass "selected"

      $(tabsHash['#' + $(this).attr('id')]).show()
      $(this).addClass "selected"