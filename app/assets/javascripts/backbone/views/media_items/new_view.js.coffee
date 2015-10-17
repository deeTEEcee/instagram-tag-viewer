InstagramTagView.Views.MediaItems ||= {}

class InstagramTagView.Views.MediaItems.NewView extends Backbone.View
  template: JST["backbone/templates/media_items/new"]

  events:
    "submit #new-media_item": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (media_item) =>
        @model = media_item
        window.location.hash = "/#{@model.id}"

      error: (media_item, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
