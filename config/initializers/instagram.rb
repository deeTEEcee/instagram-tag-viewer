Instagram.configure do |config|
  config.client_id = Rails.application.secrets.instagram["client_id"]
  config.client_secret = Rails.application.secrets.instagram["client_secret"]
  if access_token = ApiClient.first.try(:access_token)
    config.access_token = access_token
  end
end
