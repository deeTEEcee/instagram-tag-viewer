InstagramTagView.Views.Media ||= {}

class InstagramTagView.Views.Media.CollectionView extends Backbone.View
  template: JST["backbone/templates/media/collection"]

  events:
    "submit": "load"

  initialize: () ->
    _.bindAll(this, "render")

    @collection = new InstagramTagView.Collections.MediaItemsCollection()
    @collection.bind('reset', @addAll)
    test = {image_link: "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s640x640/sh0.08/e35/12106050_891707344212551_1122382914_n.jpg ", link: "https://www.google.com", tag: "tag", data_type: "image", username: "username", tagged_at: "2015-10-17"}
    @collection.reset [test, test, test, test, test, test, test, test, test]
    from_date = new Date()
    from_date.setMonth(from_date.getMonth()-1)
    from_date = from_date.toISOString()
    @from_date = from_date.substr(0, from_date.indexOf('T'))
    to_date = new Date()
    to_date = to_date.toISOString()
    @to_date = to_date.substr(0, to_date.indexOf('T'))

  load: (e) ->
    e.preventDefault()
    e.stopPropagation()

    data = {}
    $.each $('form#search').serializeArray(), (i, field) ->
      data[field.name] = field.value
    @from_date = data['from']
    @to_date = data['to']
    @tag = data['tag']

    $.ajax
      type: "POST",
      dataType: "json"
      url: "api/media"
      data: data
      context: this
      success: (data) ->
        @collection.fetch
          success: @render
          error: (collection, response, options) ->
            console.log('error')

  addAll: () =>
    @collection.each(@addOne)

  addOne: (mediaItem) =>
    view = new InstagramTagView.Views.MediaItems.MediaItemView({model : mediaItem})
    @$(".collection").append(view.render().el)

  render: =>
    @$el.html(@template(mediaItems: @collection.toJSON(), from: @from_date, to: @to_date, tag: @tag))
    @addAll()

    return this

# InstagramTagView.Views.MediaItems ||= {}

# class InstagramTagView.Views.MediaItems.IndexView extends Backbone.View
#   template: JST["backbone/templates/media_items/index"]

#   initialize: () ->
#     @collection.bind('reset', @addAll)

#   addAll: () =>
#     @collection.each(@addOne)

#   addOne: (mediaItem) =>
#     view = new InstagramTagView.Views.MediaItems.MediaItemView({model : mediaItem})
#     @$("tbody").append(view.render().el)

#   render: =>
#     @$el.html(@template(mediaItems: @collection.toJSON() ))
#     @addAll()

#     return this
