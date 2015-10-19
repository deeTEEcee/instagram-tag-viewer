InstagramTagView.Views.MediaItems ||= {}

class InstagramTagView.Views.MediaItems.MediaItemView extends Backbone.View
  template: JST["backbone/templates/media_items/media_item"]

  tagName: "div"
  className: "media-item"

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
