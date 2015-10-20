InstagramTagView.Views.Media ||= {}

class InstagramTagView.Views.Media.CollectionSearch extends Backbone.View
  template: JST["backbone/templates/media/collection"]

  events:
    "submit": "submit"

  initialize: () ->
    _.bindAll(this, "render")
    @from_date = moment().add(-1, 'months')
    @to_date = moment()

  submit: (e) ->
    e.preventDefault()
    e.stopPropagation()
    window.location.hash = "/tags"

  render: =>
    @$el.html(@template(mediaItems: null, from: @from_date, to: @to_date, tag: @tag))
    return this
