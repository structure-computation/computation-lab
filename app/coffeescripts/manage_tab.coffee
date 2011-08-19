# Selectionne le premier onglet du tableau
selectFirst = (sub_menu)->
  $(sub_menu).find('> li > a').removeClass('selected')
  $($(sub_menu).find('> li > a')[0]).addClass('selected')
  $(sub_menu).find(' > div').addClass('hide')
  $($(sub_menu).find(' > div')[0]).removeClass('hide').addClass('show')

# Selectionne le bon onglet en fonction de l'ancre présente dans l'URL
select_tab = ->
  # Ancre de l'url sans le "#"
  currentAnchor = decodeURI(location.hash.slice(1))
  currentAnchor = currentAnchor.split('_')

  $('.js_tab_submenu').each (i, sub_menu) ->
    sub_menu = $(sub_menu)
    # Si l'url contient une ancre correcte la section correspondante sera chargé
    if currentAnchor[i] and currentAnchor[i] != ""
      badHash = true
      # Vérifie si l'ancre éxiste
      for tab in sub_menu.find('> li > a')
        if $(tab).text() == currentAnchor[i]
          badHash = false
      # Cache les sections si l'ancre de l'URL est correcte
      if !badHash
        tab_content = $($(".js_tab_content")[i])
        
        sub_menu.find('> li > a').removeClass('selected')
        sub_menu.find('> li').removeClass('tab_before') # Suppression de tous les tab_before
        
        for tab, j in sub_menu.find('> li > a')
          if $(tab).text() == currentAnchor[i]
            if j > 0
              $(sub_menu.find('> li')[j - 1]).addClass('tab_before')
            $(tab).addClass('selected')
            tab_content.find('.'+$(tab).attr('id') + '_content, #'+$(tab).attr('id') + '_content').removeClass('hide').addClass('show')
          else
            tab_content.find('.'+$(tab).attr('id') + '_content, #'+$(tab).attr('id') + '_content').removeClass('show').addClass('hide')
      else
        selectFirst(sub_menu)
    else
      selectFirst(sub_menu)


# Ajout d'évènement sur les onglets du menu pour les faires aparaître comme il se doit
$('ul.js_tab_submenu').each (i, sub_menu) ->
  nav_links = $(sub_menu).find('> li > a')
  nav_links.each (j, link)->
    $(link).click  ->
      tab_content = $($(".js_tab_content")[i])
      tab_content.find(' > .show').addClass('hide')
      tab_content.find(' > .show').removeClass('show')
      $(sub_menu).find('#'+$(this).attr('id') + '_content').addClass('show')

window.onpopstate = (event) ->
  select_tab()
$ ->
  select_tab()