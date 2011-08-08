# Si l'url contient un Hash la bonne section est chargé
currentAnchor = unescape(location.hash.slice(1))

if currentAnchor != ""
  badHash = true
  for tab in $('.tab_submenu a')
    if $(tab).text() == currentAnchor
      badHash = false
  # Cache les sections uniquement si le hash de l'URL est correcte
  if !badHash
    $('.tab_content div').addClass('hide')
    $('.tab_content div').removeClass('show')
    $('ul.tab_submenu a').removeClass('selected')
    for tab in $('.tab_submenu a')
      if $(tab).text() == currentAnchor
        $(tab).addClass('selected')
        $('#'+$(tab).attr('id') + '_content').addClass('show')

else
  $($('.tab_submenu a')[0]).addClass('selected')
  $('.tab_content div').addClass('hide')
  $($('.tab_content div')[0]).removeClass('hide')
  $($('.tab_content div')[0]).addClass('show')

nav_links = $('ul.tab_submenu a')
nav_links.each( () ->
  $(this).click( () ->
    nav_links.removeClass('selected')
    $(this).addClass('selected')
    $('.tab_content .show').addClass('hide')
    $('.tab_content .show').removeClass('show')
    $('#'+$(this).attr('id') + '_content').addClass('show')
  )

)