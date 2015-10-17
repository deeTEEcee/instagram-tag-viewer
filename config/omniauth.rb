Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, Rails.application.secrets.instagram["client_id"], Rails.application.secrets.instagram["client_secret"]
end
