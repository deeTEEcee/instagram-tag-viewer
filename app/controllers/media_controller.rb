class MediaController < ApplicationController

  API_COLLECTION_SIZE = 33

  def collection_get
    page_index = params[:page_index].to_i
    # from_date = Date.parse(params[:from_date])
    tag = params[:tag]
    # no need to order, id order by default == recent -> older
    media_items = MediaItem.where(tag: params[:tag])
              .offset(page_index * API_COLLECTION_SIZE)
              .limit(API_COLLECTION_SIZE)
    # TODO: queries and do pagination
    render json: media_items
  end

  # TODO: if elements based on page_index do not exist, THEN you grab it from the previous page_index's next_max_page_id
  def collection_post
    page_index = params[:page_index].to_i
    from_date = Date.parse(params[:from_date])
    tag = params[:tag]
    rate_limit_usable = true
    tagged_within_date = true

    media_items = MediaItem.where(tag: params[:tag])
              .offset(page_index * API_COLLECTION_SIZE)
              .limit(API_COLLECTION_SIZE)
    if media_items.exists?
      render json: { message: "items already exist", code: 0}, status: 200
    else
      request_next_max_tag_id = MediaItem.where(tag: params[:tag]).last.try(:next_max_tag_id)
      response = tag_recent_media_request(params[:tag], count: API_COLLECTION_SIZE, max_tag_id: request_next_max_tag_id)
      pagination = JSON.parse(response.body)["pagination"]
      next_max_tag_id = pagination["next_max_tag_id"]

      collection = JSON.parse(response.body)["data"]
      collection.each do |media_attributes|
        tagged_at = nil
        created_time = media_attributes['created_time'].to_i
        tagged_at = Time.at(created_time) if media_attributes['tags'].include?(params[:tag])
        if !tagged_at
          comment_tagged_at_list = []
          media_attributes['comments']['data'].each do |comment|
            comment_tagged_at_list << Time.at(comment['created_time']) if comment['text'].split.include?("#{tag}")
            break
          end
          # with more than one tagged comment, get the latest one
          tagged_at = comment_tagged_at_list.max
        end
        if !tagged_at.to_date.between?(from_date, Date.today)
          tagged_within_date = false
          break
        end

        media_item = MediaItem.build_with_instagram(media_attributes)
        media_item.tagged_at = tagged_at
        media_item.tag = tag
        media_item.next_max_tag_id = next_max_tag_id
        media_item.save!
      end
      rate_limit_usable = false if response.headers[:x_ratelimit_remaining].to_i <= 0
      if !rate_limit_usable
        render json: { message: "past rate limit", code: 3 }, status: 200
      elsif !tagged_within_date # out of tags
        render json: { message: "out of tags to search for", code: 2 }, status: 200
      else
        render json: { message: "still searchable", code: 1 }, status: 200
      end
    end
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
