class MediaController < ApplicationController

  def collection_get
    # get local collections based on same params from last time
    render json: MediaItem.all
  end

  def collection_post

    from_date = Date.parse(params[:from])
    to_date = Date.parse(params[:to])
    rate_limit_usable = true
    tagged_within_date = true
    # while rate_limit_usable && tagged_within_date
    # 5.times do
    #   response = tag_recent_media_request(params[:tag], count: 33)
    #   collection = JSON.parse(response.body)["data"]
    #   collection.each do |media_attributes|
    #     tagged_at = nil
    #     created_time = media_attributes['created_time'].to_i
    #     tagged_at = Time.at(created_time) if media_attributes['tags'].include?(params[:tag])
    #     if !tagged_at
    #       comment_tagged_at_list = []
    #       media_attributes['comments']['data'].each do |comment|
    #         comment_tagged_at_list << Time.at(comment['created_time']) if comment['text'].split.include?("#{tag}")
    #         break
    #       end
    #       # with more than one tagged comment, get the latest one
    #       tagged_at = comment_tagged_at_list.max
    #     end
    #     if !tagged_at.to_date.between?(from_date, to_date)
    #       tagged_within_date = false
    #       break
    #     end

    #     media_item = MediaItem.build_with_instagram(media_attributes, tagged_at: tagged_at, tag: params[:tag])
    #     media_item.save!
    #   end
    #   rate_limit_usable = false if response.headers["x_ratelimit_limit"].to_i <= 0
    # end
    render json: { message: "testing" }, status: 200
    # if rate_limit_usable
    #   render json: { message: "testing" }, status: 200
    # else
    #   render json: { message: "testing" }, status: 200
    # end
  end

  private

  # default count is 20, max is 33 for /tag/<tag_name>/recent/media (tested with high number counts)
  def tag_recent_media_request(tag, count: nil, min_tag_id: nil, max_tag_id: nil)
    url = "https://api.instagram.com/v1/tags/#{tag}/media/recent"
    query_hash = {
      access_token: get_access_token,
      count: count,
      min_tag_id: (min_tag_id if min_tag_id),
      max_tag_id: (max_tag_id if max_tag_id)
    }
    query_hash.delete_if { |k,v| v.nil? }
    return RestClient.get url, params: query_hash
  end

end

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
