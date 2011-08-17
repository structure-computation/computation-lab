$ ->
  $('#main_menu li')[0].onGesture "tap", (event) ->
    $(this).find('ul').css 'display', 'block'
  
  $('.action_on_table')[0].onGesture "tap", ->
    ul = $(this).find('> ul')
    if ul.css('display') == 'none'
      $('.action_on_table ul').css('display','none')
      ul.css('display','block')
    else
      ul.css('display','none')
  
  $('body')[0].onGesture "tap", (eventObj) ->
    if !$(eventObj.target.target).hasClass('action_on_table')
      $('.action_on_table ul').css('display','none')
  