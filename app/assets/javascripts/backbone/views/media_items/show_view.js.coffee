InstagramTagView.Views.MediaItems ||= {}

class InstagramTagView.Views.MediaItems.ShowView extends Backbone.View
  template: JST["backbone/templates/media_items/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
