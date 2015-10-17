InstagramTagView.Views.MediaItems ||= {}

class InstagramTagView.Views.MediaItems.EditView extends Backbone.View
  template: JST["backbone/templates/media_items/edit"]

  events:
    "submit #edit-media_item": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (media_item) =>
        @model = media_item
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
