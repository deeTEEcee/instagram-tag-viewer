class InstagramTagView.Models.MediaItem extends Backbone.Model
  paramRoot: 'media_item'

  defaults:
    data_type: null
    tag: null
    link: null
    image_link: null
    username: null
    tagged_at: null

class InstagramTagView.Collections.MediaItemsCollection extends Backbone.Collection
  model: InstagramTagView.Models.MediaItem
  url: '/api/media'
