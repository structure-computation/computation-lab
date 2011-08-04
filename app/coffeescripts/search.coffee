searchFilter = (inputFieldId) ->
  $(inputFieldId).keyup( ->
    search_text = $(this).attr 'value'
    rows = $("tbody tr")
    if search_text? != ""
      for row in rows
        row = $(row)
        if row.text().toLowerCase().indexOf(search_text) != -1
          row.css('display', 'table-row')
        else
          row.css('display', 'none')
    else
      rows.css('display', 'table-row')
  )
  
advancedSearchFilter = (inputFieldIds) ->
  for inputFieldId in inputFieldIds
    searchFilter(inputFieldId)

searchFilter("#search_filter")
