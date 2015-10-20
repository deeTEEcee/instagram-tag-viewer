#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers


window.InstagramTagView =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  new InstagramTagView.Routers.MediaItemsRouter();
  Backbone.history.start();
