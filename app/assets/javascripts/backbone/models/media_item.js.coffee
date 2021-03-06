class InstagramTagView.Models.MediaItem extends Backbone.Model
  paramRoot: 'media_item'

  defaults:
    data_type: null
    tag: null
    link: null
    image_link: null
    username: null
    tagged_at: null

  parse: (response, options) ->
    response.tagged_at = moment(response.tagged_at)
    return response

class InstagramTagView.Collections.MediaItemsCollection extends Backbone.Collection
  model: InstagramTagView.Models.MediaItem
  url: '/api/media'
