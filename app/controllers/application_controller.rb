class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def get_access_token
    @access_token ||= ApiClient.first.access_token
  end

end
