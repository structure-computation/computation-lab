removeAccent = (string) ->
  string.replace(/[éèê]/g, 'e').replace(/[ùû]/g, 'u').replace('î', 'i').replace('ô', 'o')

# Cherche une occurence dans tout un tableau
# @params: tableId
#   ID du tableau dans laquelle la recherche doit être faite
# @params: inputFieldId
#   ID de l'input dans lequel l'occurence de recherche est spécifié.

window.searchFilter = (tableId, inputFieldId) ->
  # Vérifie si les ID sont passé avec le '#' et l'ajoute si non. 
  # Permet une plus grande liberté à l'utilisation.
  if inputFieldId[0] != '#'
    inputFieldId = '#'.concat(inputFieldId)
  if tableId[0] != '#'
    tableId = '#'.concat(tableId)
    
  $(inputFieldId).keyup( ->
    searchText = $(this).attr('value').toLowerCase()
    searchText = removeAccent(searchText)
    searchText = searchText.split(" ")
    rows = $(tableId + " tbody tr")
    if searchText?
      for row in rows
        row = $(row).find("> :not('td.escape_search')")

        tableContainsOccurence = true
        for text in searchText
          rowText = removeAccent (row.text().toLowerCase())
          tableContainsOccurence = false if rowText.indexOf(text) == -1
        if tableContainsOccurence
          row.parent().css('display', 'table-row')
        else
          row.parent().css('display', 'none')
    else
      rows.css('display', 'table-row')
  )

# Cherche si les occurences des inputs passé en paramêtre match dans le tableau
# Chaque input (inputFieldsId) correspond à une colonne du tableau (colClasses).

# @params: tableId
#   ID du tableau dans laquelle la recherche doit être faite
# @params: inputFieldIds
#   Les IDs des inputs dans lesquels les occurences de recherche sont spécifiées.
# @params: colClasses
#   Les classes des colonnes du tableau dans les quelles les occurences vont être recherchées

window.advancedSearchFilter = (tableId, inputFieldIds, colClasses) ->
  if tableId[0] != '#'
    tableId = '#'.concat(tableId)    
  for i in [0...inputFieldIds.length]
    if inputFieldIds[i][0] != '#'
      inputFieldIds[i] = '#'.concat(inputFieldIds[i])
    if colClasses[i][0] != '.'
      colClasses[i] = '.'.concat(colClasses[i])

  for inputFieldId in inputFieldIds
    $(inputFieldId).keyup( ->
      rows = $(tableId + " tbody tr")
      for row in rows
        row = $(row)
        occurenceFound = true
        for i in [0...inputFieldIds.length]
          cellText  = row.find(colClasses[i]).text().toLowerCase()
          occurence = $(inputFieldIds[i]).attr('value').toLowerCase()
          if cellText.indexOf(occurence) == -1
            occurenceFound = false
        if occurenceFound
            row.css('display', 'table-row')
        else
            row.css('display', 'none')
    )
