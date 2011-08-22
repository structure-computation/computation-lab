$ ->
  Steps   = new StepCollection
  window.StepsView = new StepListView collection: Steps

  # Initialisation of a factice PieceCollection
  pieceCollection = new PieceCollection(
    [{
          "group": -1,
          "name": "piece 0",
          "origine": "from_bulkdata",
          "assigned": -1,
          "id": 0,
          "identificateur": 0
        },
        {
          "group": -1,
          "name": "piece 1",
          "origine": "from_bulkdata",
          "assigned": -1,
          "id": 1,
          "identificateur": 1
        },
        {
          "group": -1,
          "name": "piece 2",
          "origine": "from_bulkdata",
          "assigned": -1,
          "id": 2,
          "identificateur": 2
        },
        {
          "group": -1,
          "name": "piece 3",
          "origine": "from_bulkdata",
          "assigned": -1,
          "id": 3,
          "identificateur": 3
        }
        ])
  # /!\ Le nom ne doit pas être changé ! /!\
  window.pieceListView = new PieceListView collection : pieceCollection
  
  
  window.router = new Router
  Backbone.history.start()
