class InstagramTagView.Routers.MediaItemsRouter extends Backbone.Router
  # initialize: (options) ->

  routes:
    "" : "search"
    "tags": "tags"

  search: ->
    console.log('search')
    @view = new InstagramTagView.Views.Media.CollectionSearch()
    console.log('rendering')
    $("#media").html(@view.render().el)


  tags: ->
    console.log('tags')
    @view = new InstagramTagView.Views.Media.CollectionView()
    $("#media").html(@view.render().el)
