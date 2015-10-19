InstagramTagView.Views.Media ||= {}

# TODO: save form data state so that we can go "back" in the same browser window to the posted state (should i keep this view separate?)
# For saving state, save it in local storage instead and possibly with a separate model?

API_COLLECTION_SIZE = 33

class InstagramTagView.Views.Media.CollectionView extends Backbone.View
  template: JST["backbone/templates/media/collection"]

  events:
    "submit": "submit"

  initialize: () ->
    # _.bindAll(this, "addSet", "load") # setupMasonry
    @detectScroll()
    opts = { position: 'relative', top: '50px' }

    @paginationIndex = 0
    @collection = new InstagramTagView.Collections.MediaItemsCollection()
    @from_date = null
    @to_date = null
    @tag = null
    @initForm()
    @load()

  initForm: () ->
    form_params = {}
    $.each $('form#search').serializeArray(), (i, field) ->
      form_params[field.name] = field.value
    @from_date = form_params['from']
    @to_date = form_params['to']
    @tag = form_params['tag']

  load: () ->
    $('img#spin').show()
    that = this
    params =
      page_index: @paginationIndex
      from_date: @from_date
      to_date: @to_date
      tag: @tag

    $.ajax
      type: "POST",
      dataType: "json"
      url: "api/media"
      data: params
      context: this
      success: (data) ->
        if data.code == 0 || data.code == 1
          @collection.fetch
            data: params
            success: () ->
              console.log('get collection')
              that.addSet()
              that.paginationIndex += 1
              $('img#spin').hide()
            error: (collection, response, options) ->
              console.log('error')
        else if data.code == 2
          console.log('out of tags to search for')
        else if data.code == 3
          console.log('code rate limit exceeded')

  detectScroll: () ->
    that = @
    throttled = _.throttle(
     (() ->
      if ($(window).scrollTop() + $(window).height() == $(document).height())
        console.log('scrolling')
        that.scrolledToBottom = true
        that.load()
     ), 500)
    $(window).scroll(throttled)

  submit: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @load()

  addSet: () ->
    that = this
    startIndex = @paginationIndex * API_COLLECTION_SIZE
    _.each @collection.models, (model) ->
      that.addOne(model)
    # _.each @collection.models.slice(startIndex, startIndex + API_COLLECTION_SIZE), (model) ->
      # that.addOne(model)

  addOne: (mediaItem) ->
    view = new InstagramTagView.Views.MediaItems.MediaItemView({model : mediaItem})
    @$("#media-collection").append(view.render().el)

  # setupMasonry: () ->
  #   @$('#media-collection').masonry({
  #     itemSelector: '.media-item',
  #     columnWidth: 20
  #   })


  render: ->
    @$el.html(@template(mediaItems: @collection.toJSON(), from: @from_date, to: @to_date, tag: @tag))
    # setTimeout @setupMasonry, 0



    return this
