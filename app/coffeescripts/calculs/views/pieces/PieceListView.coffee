## PieceListView
SCViews.PieceListView = Backbone.View.extend
  el: '#pieces'
  
  # You have to pass a PieceCollection at initialisation as follow:
  # new SCVisu.pieceListView({ collection : myPieceCollection })
  initialize: ->
    @clearView()
    @pieceViews = []
    for piece in @collection.models
      @pieceViews.push new SCViews.PieceView model: piece, parentElement: this
    @selectedPieceView = null
    @render()
    $(@el).find('table').tablesorter()

    @collection.bind 'add'   , @saveCalcul, this
    @collection.bind 'change', @saveCalcul, this
    @collection.bind 'remove', @saveCalcul, this

     # Triggered when a piece is clicked
    @bind "selection_changed:pieces", (selectedPieceView) =>
      @render() # Reset all views
      if @selectedPieceView == selectedPieceView
        @selectedPieceView.deselect()
        @selectedPieceView = null
        SCVisu.materialListView.trigger("selection_changed:pieces", null)
      else
        @selectedPieceView.deselect() if @selectedPieceView
        @selectedPieceView = selectedPieceView
        @selectedPieceView.select()
        @selectedPieceView.showUnassignMaterialButton() if @selectedPieceView.model.isAssigned()
        SCVisu.materialListView.trigger("selection_changed:pieces", @selectedPieceView)


     # Triggered when a material is clicked
    @bind "selection_changed:materials", (selectedMaterialsView) =>
      @selectedPieceView.deselect() if @selectedPieceView
      @selectedPieceView = null
      @render() # Reset all views
      if selectedMaterialsView != null
        $("button.assign_all, button.unassign_all").removeAttr('disabled')
        # On each piece, 
        # - If it is not assigned yet                                       -> we show an assign button
        # - If it is assigned and have the same id of the selected material -> We show Unassigned button
        # - Else, we do nothing
        _.each @pieceViews, (pieceView) =>
          if _.isUndefined(pieceView.model.get('material_id'))
            pieceView.showAssignButton()
          else if pieceView.model.get('material_id') == selectedMaterialsView.model.getId()
            pieceView.select()
            pieceView.showUnassignButton()

    # Check if a piece had the material associated to it before. 
    # If it is the case, then it removes the association
    @bind "action:removed_material", (materialView) =>
      _.each @collection.models, (piece) ->
        if piece.get('material_id') == materialView.model.getId()
          piece.unset 'material_id'
      @render()

    # Triggered when the unassigned button of a material is clicked.
    # Unassign the material from the current piece
    @bind "action:unassign:material", (materialView) =>
      @selectedPieceView.model.unset "material_id"
      @selectedPieceView.render()
      @selectedPieceView.select()

    # Triggered when the assigned button of a material is clicked.
    # Assign the current piece to the given material view
    @bind "action:assign:material", (materialView) =>
      @selectedPieceView.model.set material_id: materialView.model.getId()
      @selectedPieceView.render()
      @selectedPieceView.showUnassignMaterialButton()
      @selectedPieceView.select()

    # Triggered when the assigned button of a piece is clicked.
    # Assign the current piece to the currently selected material
    @bind "action:assign:piece", (pieceView) =>
      pieceView.model.set material_id: SCVisu.materialListView.selectedMaterialView.model.getId()
      pieceView.showUnassignButton()
      pieceView.select()
      
    # Triggered when the unassigned button of a piece is clicked.
    # Unassign the material from the current piece
    @bind "action:unassign:piece", (pieceView) =>
      pieceView.model.unset "material_id"
      pieceView.showAssignButton()

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#pieces' element already exists in the DOM and every time we create a PiecesListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new PiecesListView 
  clearView: ->
   $(@el).find('tbody').html('')
    
  events:
    'change input#hide_assigned_pieces'   : 'toggleAssignedPieces'
    'change select#filter_type'           : 'setTypeFilter'
    'click button.assign_all'             : 'assignAllVisiblePieces'
    'click button.unassign_all'           : 'unassignAllVisiblePieces'
    'click button.filter'                 : 'filterPieces'
    'click button.cancel_filter'          : 'cancelFilter'
    'click button.view_filter'            : 'viewPieces'

  setTypeFilter: (event) ->
    @filterValue = event.srcElement.value
    
  cancelFilter: ->
    $(@el).find('button.cancel_filter').attr('disabled','disabled')
    # Show everything
    _.each @pieceViews, (pieceView) ->
      $(pieceView.el).show()
      pieceView.showView()
    @viewPieces()
  
  filterPieces: ->
    filter = $(@el).find('input').val()
    @filteredPieces = []
    $(@el).find('button.cancel_filter').removeAttr('disabled')
    # Hide everything
    _.each @pieceViews, (pieceView) ->
        $(pieceView.el).hide()
        pieceView.hideView()
    
    if @filterValue == "materials" 
        group = filter.split(",")
        for group_id in group
            piece_id = parseFloat(group_id)
            #alert piece_id
            _.each @pieceViews, (pieceView) ->  
              if pieceView.model.get('material_id') == piece_id
                $(pieceView.el).show()
                pieceView.showView()
      
    else if @filterValue == "id"
        group = filter.split(",")
        #alert group.length
        for group_id in group
            group_modulo = group_id.split("%")
            #alert group_modulo.length
            if group_modulo.length==2
                range = group_modulo[0].split("-")
                modulo_id = parseInt(group_modulo[1])
                modulo = 0
                out = true
                while out
                    piece_id = []
                    if range.length==2
                        piece_id[0] = parseFloat(range[0]) + modulo
                        piece_id[1] = parseFloat(range[1]) + modulo
                        _.each @pieceViews, (pieceView) ->
                            if pieceView.model.get('id') >= piece_id[0] and pieceView.model.get('id') <= piece_id[1]
                              $(pieceView.el).show()
                              pieceView.showView()
                    else if range.length==1
                        piece_id[0] = parseFloat(range[0]) + modulo
                        _.each @pieceViews, (pieceView) ->
                          if pieceView.model.get('id') == piece_id[0]
                            $(pieceView.el).show()
                            pieceView.showView()
                    modulo += modulo_id
                    if (parseFloat(range[0]) + modulo) > @pieceViews.length
                        #alert modulo
                        #alert parseFloat(piece_id[0]) + modulo
                        #alert @pieceViews.length
                        out = false
                        break
                        
            else if group_modulo.length==1
                range = group_modulo[0].split("-")
                piece_id = []
                if range.length==2
                    piece_id[0] = parseFloat(range[0])
                    piece_id[1] = parseFloat(range[1])
                    _.each @pieceViews, (pieceView) ->
                      if pieceView.model.get('id') >= piece_id[0] and pieceView.model.get('id') <= piece_id[1]
                        $(pieceView.el).show()
                        pieceView.showView()
                else if range.length==1
                    piece_id[0] = parseFloat(range[0])
                    _.each @pieceViews, (pieceView) ->  
                      if pieceView.model.get('id') == piece_id[0]
                        $(pieceView.el).show()
                        pieceView.showView()
          
      
    #@viewPieces()
    
    #range = filter.split('-')
    #range = [filter]
    #alert  range
    #_.each @pieceViews, (pieceView) ->
    #  if pieceView.model.get('id') in range
    #    $(pieceView.el).show()
    #  else 
    #    $(pieceView.el).hide()

  viewPieces: ->
    SCVisu.visualisation.view_filter("pieces")   
      
  # If the checkbox is checked, hide all assigned pieces
  toggleAssignedPieces: (event) ->
    if event.srcElement.checked
      _.each @pieceViews, (pieceView) ->
        $(pieceView.el).hide() if pieceView.model.isAssigned()
    else
      _.each @pieceViews, (pieceView) ->
        $(pieceView.el).show()

  # Assign all visible pieces which are visible to the selected material
  assignAllVisiblePieces: ->
    _.each @pieceViews, (pieceView) ->
      if $(pieceView.el).is(':visible')
        pieceView.model.set "material_id" : SCVisu.materialListView.selectedMaterialView.model.getId()
        pieceView.showUnassignButton()

  # Assign all visible pieces which are visible to the selected material
  unassignAllVisiblePieces: ->
    _.each @pieceViews, (pieceView) ->
      if $(pieceView.el).is(':visible')
        pieceView.model.unset "material_id"
        pieceView.showAssignButton()

  saveCalcul: ->
    SCVisu.current_calcul.set pieces: @collection.models
    SCVisu.current_calcul.set materials: SCVisu.materialListView.collection.models
    SCVisu.current_calcul.trigger 'change'

  render : ->
    $("button.assign_all, button.unassign_all").attr('disabled', 'disabled')
    _.each @pieceViews, (pieceView) ->
      pieceView.render()
      pieceView.deselect()
    return this

  getPiece: (pieceID) ->
    # I don't go through @collection.each because it would go through all 
    # elements and would not stop on return statement
    for piece in @collection.models
      if parseInt(piece.get('id'),10) == parseInt(pieceID,10)
        return piece

  