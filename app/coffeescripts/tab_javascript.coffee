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