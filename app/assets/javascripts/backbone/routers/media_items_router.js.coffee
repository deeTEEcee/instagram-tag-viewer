class InstagramTagView.Routers.MediaItemsRouter extends Backbone.Router
  initialize: (options) ->
    # @mediaItems = new InstagramTagView.Collections.MediaItemsCollection()
    # @mediaItems.reset options.mediaItems

  routes:
    "" : "search"
    "tags": "tags"
    # "new"      : "newMediaItem"
    # "index"    : "index"
    # ":id/edit" : "edit"
    # ":id"      : "show"
    # ".*"        : "index"

  search: ->
    console.log('search')
    @view = new InstagramTagView.Views.Media.CollectionSearch()
    console.log('rendering')
    $("#media").html(@view.render().el)


  tags: ->
    console.log('tags')
    @view = new InstagramTagView.Views.Media.CollectionView()
    $("#media").html(@view.render().el)

  # newMediaItem: ->
  #   @view = new InstagramTagView.Views.MediaItems.NewView(collection: @media_items)
  #   $("#media_items").html(@view.render().el)

  # index: ->
  #   @view = new InstagramTagView.Views.MediaItems.IndexView(collection: @media_items)
  #   $("#media_items").html(@view.render().el)

  # show: (id) ->
  #   media_item = @media_items.get(id)

  #   @view = new InstagramTagView.Views.MediaItems.ShowView(model: media_item)
  #   $("#media_items").html(@view.render().el)

  # edit: (id) ->
  #   media_item = @media_items.get(id)

  #   @view = new InstagramTagView.Views.MediaItems.EditView(model: media_item)
  #   $("#media_items").html(@view.render().el)
