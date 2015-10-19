class CreateMediaItems < ActiveRecord::Migration
  def change
    create_table :media_items do |t|
      t.string :data_type
      t.string :tag
      t.string :link
      t.string :image_link
      t.string :username
      t.string :next_max_tag_id
      t.datetime :tagged_at
      t.text :raw_info

      t.timestamps null: false
    end
  end
end
