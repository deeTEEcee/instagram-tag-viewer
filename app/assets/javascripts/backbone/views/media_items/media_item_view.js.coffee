InstagramTagView.Views.MediaItems ||= {}

class InstagramTagView.Views.MediaItems.MediaItemView extends Backbone.View
  template: JST["backbone/templates/media_items/media_item"]

  # events:
    # "click .destroy" : "destroy"

  tagName: "div"
  className: "media-item"

  # destroy: () ->
    # @model.destroy()
    # this.remove()

    # return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
