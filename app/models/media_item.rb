class MediaItem < ActiveRecord::Base
  class << self
    def build_with_instagram(data, tagged_at: nil, tag: nil)
      media = MediaItem.new(data_to_attributes(data, tagged_at: tagged_at, tag: tag))
    end

    def data_to_attributes(data, tagged_at: nil, tag: nil)
      {
        tag: tag,
        data_type: data['type'],
        link: data['link'],
        image_link: data['images']['standard_resolution']['url'],
        username: data['user']['username'],
        tagged_at: tagged_at,
        raw_info: data.to_json
      }
    end
  end
end
