# Selectionne le premier onglet du tableau
selectFirst = ->
  $($('.js_tab_submenu a')[0]).addClass('selected')
  $('.tab_content > div').addClass('hide')
  $($('.tab_content > div')[0]).removeClass('hide')
  $($('.tab_content > div')[0]).addClass('show')

select_tab = ->
  # Ancre de l'url sans le "#"
  currentAnchor = unescape(location.hash.slice(1))

  # Si l'url contient une ancre correcte la section correspondante sera chargé
  if currentAnchor != ""
    badHash = true
    # Vérifie si l'ancre éxiste
    for tab in $('.js_tab_submenu a')
      if $(tab).text() == currentAnchor
        badHash = false
    # Cache les sections si l'ancre de l'URL est correcte
    if !badHash
      $('.tab_content > div').addClass('hide')
      $('.tab_content > div').removeClass('show')
      $('ul.js_tab_submenu a').removeClass('selected')
      for tab in $('.js_tab_submenu a')
        if $(tab).text() == currentAnchor
          $(tab).addClass('selected')
          $('#'+$(tab).attr('id') + '_content').addClass('show')
    else 
      selectFirst()
  else
    selectFirst()


# Ajout d'évènement sur les onglets du menu pour les faires aparaître comme il se doit
nav_links = $('ul.js_tab_submenu a')
nav_links.each( () ->
  $(this).click( () ->
    nav_links.removeClass('selected')
    $(this).addClass('selected')
    $('.tab_content .show').addClass('hide')
    $('.tab_content .show').removeClass('show')
    $('#'+$(this).attr('id') + '_content').addClass('show')
  )

)

window.onpopstate = ->
  select_tab()