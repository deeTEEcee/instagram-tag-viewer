class MediaItem < ActiveRecord::Base
  class << self
    def build_with_instagram(data)
      media = MediaItem.new(data_to_attributes(data))
    end

    def data_to_attributes(data, tagged_at: nil, tag: nil)
      {
        data_type: data['type'],
        link: data['link'],
        image_link: data['images']['standard_resolution']['url'],
        username: data['user']['username'],
        raw_info: data.to_json
      }
    end
  end
end
