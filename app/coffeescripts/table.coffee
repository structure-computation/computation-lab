# Dans l'interface Structure Computation, de nombreux tableaux (modèles, membres d'une équipe...) utilisent
# un menu déroulant caché dans la dernière colone. Cette colonne est appellée la colone action. Ce fichier 
# Javascript gère l'affichage du menu.
$( ->
  # Fait apparaitre ou disparaitre le menu déroulant lors du click sur la flêche dans la colonne "action"
  $('.action_on_table').click( ->
    ul = $(this).find('> ul')
    if ul.css('display') == 'none'
      $('.action_on_table ul').css('display','none')
      ul.css('display','block')
    else
      ul.css('display','none')
  )

  # Fait disparaitre le menu des actions lorsqu'on clique hors de la colonne actions
  $('body').click ( (eventObj)->
    if !$(eventObj.srcElement).hasClass('action_on_table')
      $('.action_on_table ul').css('display','none')
  )

)