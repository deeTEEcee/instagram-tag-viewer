InstagramTagView.Views.MediaItems ||= {}

class InstagramTagView.Views.Media.MediaItemView extends Backbone.View
  template: JST["backbone/templates/media/media_item"]

  tagName: "div"
  className: "media-item"

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
