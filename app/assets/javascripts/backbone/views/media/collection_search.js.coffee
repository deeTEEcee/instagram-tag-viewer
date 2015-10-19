InstagramTagView.Views.Media ||= {}

class InstagramTagView.Views.Media.CollectionSearch extends Backbone.View
  template: JST["backbone/templates/media/collection"]

  events:
    "submit": "submit"

  initialize: () ->
    _.bindAll(this, "render")

    @collection = new InstagramTagView.Collections.MediaItemsCollection()
    @collection.bind('reset', @render)
    test = {image_link: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s640x640/sh0.08/e35/12106050_891707344212551_1122382914_n.jpg ", link: "https://www.google.com", tag: "tag", data_type: "image", username: "username", tagged_at: "2015-10-17"}
    @collection.reset [test, test, test, test, test, test, test, test, test]
    from_date = new Date()
    from_date.setMonth(from_date.getMonth()-1)
    from_date = from_date.toISOString()
    @from_date = from_date.substr(0, from_date.indexOf('T'))
    to_date = new Date()
    to_date = to_date.toISOString()
    @to_date = to_date.substr(0, to_date.indexOf('T'))

  submit: (e) ->
    e.preventDefault()
    e.stopPropagation()
    window.location.hash = "/tags"

  addAll: () =>
    @collection.each(@addOne)

  addOne: (mediaItem) =>
    view = new InstagramTagView.Views.MediaItems.MediaItemView({model : mediaItem})
    @$("#media-collection").append(view.render().el)

  setupMasonry: () =>
    @$('#media-collection').masonry({
      itemSelector: '.media-item',
      columnWidth: 20
    })
    opts = { position: 'relative', top: '50px' }



  render: =>
    @$el.html(@template(mediaItems: @collection.toJSON(), from: @from_date, to: @to_date, tag: @tag))
    @addAll()
    # TODO: need to udnerstand why this does not work outside the DOM
    setTimeout @setupMasonry, 0

    return this
