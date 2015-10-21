class MediaItem < ActiveRecord::Base
  class << self
    def build_with_instagram(data)
      media = MediaItem.new(data_to_attributes(data))
    end

    def data_to_attributes(data, tagged_at: nil, tag: nil)
      data_type = data['type']
      video_link = data['type'] == 'video' ? data['videos']['low_bandwidth']['url'] : nil
      {
        data_type: data_type,
        link: data['link'],
        image_link: data['images']['standard_resolution']['url'],
        video_link: video_link,
        username: data['user']['username'],
        raw_info: data.to_json
      }
    end
  end
end
