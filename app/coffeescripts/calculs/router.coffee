# Manage the overall calculus wizard.
# It handles anchors URLs
SCVisu.Router = Backbone.Router.extend
  initialize: ->
    @initialisation()
    @disaleTabs()
    @currentPage = 0 # First page is 0. 
    # Bind click event on previous and next button
    # Load next page
    $("#wizard_previous_button").click =>
      if $(@).attr('disabled') != 'disabled'
        @previousPage()
    .attr 'disabled', 'disabled' # Disable the previous button on load.
    # If user is on the first page, then the selected calculus is loaded, else it loads next page.
    $("#wizard_next_button").click =>
      if @currentPage == 0
        SCVisu.calculViews.loadCalcul()
      else
        @nextPage()
    # Take care that when the user change 'step' in the wizard, the two lists
    $('#wizard_previous_button, #wizard_next_button, #breadcrumb a').click =>
      $('#list_calcul > div') .slideDown()
      $('#visu_calcul').show() if @currentPage > 0
      
    $("#save_calcul").click =>
      if SCVisu.current_calcul
        SCVisu.calculViews.saveCalcul()
        
    # Names of breadcrumb's anchors. 
    # Used in Next And Previous functions
    @routesPageNumber = [ 
       "Initialization"      
       "Parameters"
       "Materials"          
       "Links"              
       "Volumic_forces"     
       "Boundary_Conditions"   
       "Forecast"           
    ]
  
  # It is important to call this function AFTER currentPage has changed
  # Handle to disable Next or Previous button
  handlePreviousAndNextButtons: ->
    $("#wizard_previous_button").removeAttr 'disabled'
    $("#wizard_next_button").removeAttr 'disabled'
    if @currentPage == 0
      $("#wizard_previous_button").attr 'disabled', 'disabled'
    else if @currentPage == (@routesPageNumber.length - 1)
      $("#wizard_next_button").attr 'disabled', 'disabled'

  # Each step of the wizard
  routes:
    "Initialization"      : "initialisation"
    "Parameters"          : "parameters"
    "Materials"           : "materials"
    "Links"               : "links"
    "Volumic_forces"      : "volumicForces"
    "Boundary_Conditions" : "conditions"
    "Forecast"            : "forecast"
  
  # Hide all 'tabs' and show the first one - Initialization part
  initialisation: ->
    # The visu part is put visible (.show()) in the main when a calcul has been loaded.
    $('#visu_calcul').hide()
    @currentPage = 0
    @handlePreviousAndNextButtons()
    @hideAllContent()
    @selectCorrectTab '','Initialization'
    @showContent      'initialization'

  # Hide all 'tabs' and show the Options part.
  parameters: ->
    @currentPage = 1
    @handlePreviousAndNextButtons()
    @hideAllContent()
    @selectCorrectTab 'Initialization', 'Parameters'
    @showContent      'options'

  # Hide all 'tabs' and show the Material part.
  materials: ->
    @currentPage = 2
    @handlePreviousAndNextButtons()
    @hideAllContent()
    @selectCorrectTab 'Parameters','Materials'
    @showContent      'materials'

  # Hide all 'tabs' and show the Link part.
  links: ->
    @currentPage = 3
    @handlePreviousAndNextButtons()
    @hideAllContent()
    @selectCorrectTab 'Materials', 'Links'
    @showContent      'links'

  # Hide all 'tabs' and show the Conditions part.
  volumicForces: ->
    @currentPage = 4
    @handlePreviousAndNextButtons()
    @hideAllContent()
    @selectCorrectTab 'Links', 'Volumic_forces'
    @showContent      'volumic_forces'
    
  # Hide all 'tabs' and show the Conditions part.
  conditions: ->
    @currentPage = 5
    @handlePreviousAndNextButtons()
    @hideAllContent()
    @selectCorrectTab 'Volumic_forces', 'Boundary_Conditions'
    @showContent      'boundary_conditions'

  # Hide all 'tabs' and show the Prevision part.
  forecast: ->
    @currentPage = 6
    @handlePreviousAndNextButtons()
    @hideAllContent()
    @selectCorrectTab 'Boundary_Conditions', 'Forecast'
    @showContent      'forecast'
  
  # Ajoute les classes css 'tab_before' et 'selected' aux onglets choisis et de supprimer ces mêmes classes sur tous les autres onglets
  # Le premier paramètre est une string correpondant a l'ancre du lien de l'onglet précédant celui que l'on veut sélectionner  
  # Le second paramètre est une string correpondant a l'ancre du lien de l'onglet que l'on souhaite séléctionner
  selectCorrectTab: (previousTab, currentTab) ->
    # Supprime la classe 'selected' de tous les liens de tous les onglets et supprime la classe 'tab_before' de tous les 'li' de tous les onglets
    $('.js_tab_breadcrumb li a').removeClass('selected').parent().removeClass('tab_before')
    $("a[href=##{previousTab}]").parent().addClass('tab_before')
    $("a[href=##{currentTab}]" ).addClass('selected')
    
  # Masque toutes les zones de contenu en ajoutant le classe css 'Al' à ces derniers  
  hideAllContent: ->
    $('#list_calcul       > div').removeClass('show').addClass('hide')
    $('#bottom_list_calcul> div').removeClass('show').addClass('hide')
    $('#details_calcul    > div').hide()
    $('#right_list_calcul > div').removeClass('show').addClass('hide')
    $('#left_list_calcul  > div').removeClass('show').addClass('hide')
  
  # Affiche le zone de contenu souhaité en ajoutant le classe css 'show' à cette dernière    
  showContent: (class_name) ->
    $(".#{class_name}").addClass 'show' 

  # Add a class disable and remove href attributes to all links of the breadcrumb in order 
  # to prevent the user to go on next step when a calculus has not been load yet
  disaleTabs: ->
    $('.js_tab_breadcrumb li').addClass('disable')
    _.each $('.js_tab_breadcrumb li a'), (element, index) ->
      $(element).removeAttr('href') if index > 0
  
  # Puts back all hrefs for links of the breadcrumb
  reenableTabs: ->
    $('.js_tab_breadcrumb li').removeClass('disable')
    $($('.js_tab_breadcrumb li a')[1]).attr('href', '#Parameters'         )
    $($('.js_tab_breadcrumb li a')[2]).attr('href', '#Materials'          )
    $($('.js_tab_breadcrumb li a')[3]).attr('href', '#Links'              )
    $($('.js_tab_breadcrumb li a')[4]).attr('href', '#Volumic_forces'     )
    $($('.js_tab_breadcrumb li a')[5]).attr('href', '#Boundary_Conditions')
    $($('.js_tab_breadcrumb li a')[6]).attr('href', '#Forecast'           )

  # Is executed when the calcul is loading
  calculIsLoading: ->
    $('#ajax-loader').show()
    @disaleTabs()

  # Is executed when the calcul is loading
  calculIsCreating: ->
    @calculIsLoading()

  calculHasBeenCreated: ->
    @reenableTabs()
    $('#ajax-loader').hide()

  # Is executed when the calcul has been loaded
  # Drive the user on the Time page and reenable links of the breadcrumbs
  calculHasBeenLoad: ->
    @reenableTabs()
    $('#ajax-loader').hide()
    # Put the correct anchor in the URL
    @navigate('Parameters', true)

  # Is executed when the calcul couldn't be loaded
  calculLoadError: ->
    $('#ajax-loader').hide()
      
  # Show previous page if not on the first page
  previousPage: ->
    if @currentPage > 0
      @navigate @routesPageNumber[@currentPage - 1], true
      
  # Show next page if not on the last page and only if a calculus has been loaded
  nextPage: ->
    SCVisu.calculViews.saveCalcul()
    if @currentPage < @routesPageNumber.length
      @navigate @routesPageNumber[@currentPage + 1], true

