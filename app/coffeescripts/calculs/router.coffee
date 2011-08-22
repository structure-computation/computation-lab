window.Router = Backbone.Router.extend
  routes:
    "Initialisation"     : "initialisation"
    "Temps"              : "temps"
    "Matériaux"          : "materiaux"
    "Liaisons"           : "liaisons"
    "Conditions_Limites" : "conditions"
    "Options"            : "options"
    "Prévisions"         : "previsions"
    
  initialisation: ->
    @hideAllContent()
    @selectCorrectTab '','Initialisation'
    @showContent 'tab_11_content'
    
  temps: ->
    @hideAllContent()
    @selectCorrectTab 'Initialisation','Temps'
    @showContent 'tab_12_content'
    
  materiaux: ->
    @hideAllContent()
    @selectCorrectTab 'Temps','Matériaux'
    @showContent 'tab_13_content'

  liaisons: ->
    @hideAllContent()
    @selectCorrectTab 'Matériaux', 'Liaisons'
    @showContent 'tab_14_content'

  conditions: ->
    @hideAllContent()
    @selectCorrectTab 'Liaisons', 'Conditions_Limites'
    @showContent 'tab_15_content'

  options: ->
    @hideAllContent()
    @selectCorrectTab 'Conditions_Limites', 'Options'
    @showContent 'tab_16_content'

  previsions: ->
    @hideAllContent()
    @selectCorrectTab 'Options', 'Prévisions'
    @showContent 'tab_17_content'
  
  # Ajoute les classes css 'tab_before' et 'selected' aux onglets choisis et de supprimer ces mêmes classes sur tous les autres onglets
  # Le premier paramètre est une string correpondant a l'ancre du lien de l'onglet précédant celui que l'on veut sélectionner  
  # Le second paramètre est une string correpondant a l'ancre du lien de l'onglet que l'on souhaite séléctionner
  selectCorrectTab: (previousTab, currentTab) ->
    # Supprime la classe 'selected' de tous les liens de tous les onglets et supprime la classe 'tab_before' de tous les 'li' de tous les onglets
    $('.js_tab_submenu li a').removeClass('selected').parent().removeClass('tab_before')
    $("a[href=##{previousTab}]").parent().addClass('tab_before')
    $("a[href=##{currentTab}]").addClass('selected')
    
  # Masque toutes les zones de contenu en ajoutant le classe css 'hide' à ces derniers  
  hideAllContent: ->
    $('#list_calcul > div').removeClass('show').addClass('hide')
    $('#details_calcul > div').removeClass('show').addClass('hide')
    $('#right_list_calcul > div').removeClass('show').addClass('hide')
    $('#left_list_calcul > div').removeClass('show').addClass('hide')
  
  # Affiche le zone de contenu souhaité en ajoutant le classe css 'show' à cette dernière    
  showContent: (class_name) ->
    $('.#{class_name}').addClass 'show' 