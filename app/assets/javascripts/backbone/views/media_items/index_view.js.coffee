InstagramTagView.Views.MediaItems ||= {}

class InstagramTagView.Views.MediaItems.IndexView extends Backbone.View
  template: JST["backbone/templates/media_items/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (mediaItem) =>
    view = new InstagramTagView.Views.MediaItems.MediaItemView({model : mediaItem})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(mediaItems: @collection.toJSON() ))
    @addAll()

    return this
