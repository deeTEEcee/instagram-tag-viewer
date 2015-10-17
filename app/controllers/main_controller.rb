class MainController < ApplicationController

  before_filter :setup_omniauth

  # temporarily, this is the "get" collection. afterwards, move it separate as an ajax call
  def index
  end

  def setup_omniauth
    if !ApiClient.first
      redirect_to "https://api.instagram.com/oauth/authorize/?client_id=#{Rails.application.secrets.instagram['client_id']}&redirect_uri=#{auth_callback_url(provider: :instagram)}&response_type=code"
    end
  end
end
