Rails.application.routes.draw do
  root 'main#index'

  get '/auth/:provider/callback', to: 'auth#create', as: :auth_callback
  scope :api do
    get 'media', to: 'media#collection_get'
    post 'media', to: 'media#collection_post'
  end
end
