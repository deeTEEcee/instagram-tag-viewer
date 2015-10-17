class AuthController < ApplicationController
  def create
    conn = Faraday.new(url: 'https://api.instagram.com')
    response = conn.post 'oauth/access_token', {
                                      client_id: Rails.application.secrets.instagram['client_id'],
                                      client_secret: Rails.application.secrets.instagram['client_secret'],
                                      grant_type: 'authorization_code',
                                      code: params[:code],
                                      redirect_uri: auth_callback_url(provider: :instagram)}
    attributes = JSON.parse(response.body).slice("access_token")
    client = ApiClient.new(attributes)
    client.save!
    redirect_to root_path
  end
end
