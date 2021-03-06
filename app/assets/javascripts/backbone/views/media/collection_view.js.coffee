InstagramTagView.Views.Media ||= {}

# TODO: save form data state so that we can go "back" in the same browser window to the posted state (should i keep this view separate?)
# For saving state, save it in local storage instead and possibly with a separate model?

API_COLLECTION_SIZE = 33

class InstagramTagView.Views.Media.CollectionView extends Backbone.View
  template: JST["backbone/templates/media/collection"]

  events:
    "submit": "submitRefresh"

  initialize: () ->
    @detectScroll()
    opts = { position: 'relative', top: '50px' }

    @paginationIndex = 0
    @collection = new InstagramTagView.Collections.MediaItemsCollection()
    @from_date = null
    @to_date = null
    @tag = null

  initForm: () ->
    form_params = {}
    $.each $('form#search').serializeArray(), (i, field) ->
      form_params[field.name] = field.value
    @from_date = moment(form_params['from'])
    @to_date = moment(form_params['to'])
    @tag = form_params['tag']

  refresh: () ->
    @paginationIndex = 0
    @collection = new InstagramTagView.Collections.MediaItemsCollection()
    @render()

  submitRefresh: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @refresh()

  load: () ->
    $('img#spin').show()
    that = this
    params =
      page_index: @paginationIndex
      from_date: @from_date.format('YYYY-MM-DD')
      to_date: @to_date.format('YYYY-MM-DD')
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
              that.addSet()
              that.paginationIndex += 1
              $('img#spin').hide()
            error: (collection, response, options) ->
              console.log('error')
        else if data.code == 2
          $(window).unbind('scroll')
          $('img#spin').hide()
          alert('There is no more media for this tag available.')
        else if data.code == 3
          $(window).unbind('scroll')
          $('img#spin').hide()
          alert('API Rate Limit Exceeded.')
      # TODO: handle error cases for messages (i've handled it on the server side but client side has not)

  detectScroll: () ->
    that = @
    throttled = _.throttle(
     (() ->
      if ($(window).scrollTop() + $(window).height() == $(document).height())
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

  addOne: (mediaItem) ->
    view = new InstagramTagView.Views.Media.MediaItemView({model : mediaItem})
    viewElements = view.render().el
    @$("#media-collection").append(viewElements).masonry('appended', viewElements)

  setupMasonry: () ->
    @$('#media-collection').masonry({
      itemSelector: '.media-item',
      columnWidth: 200,
      isFitWidth: true
    })

  render: () ->
    @initForm()
    @$el.html(@template(from: @from_date, to: @to_date, tag: @tag))
    @load()
    setTimeout @setupMasonry, 0
    return this
