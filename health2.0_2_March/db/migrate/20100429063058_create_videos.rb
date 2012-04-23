class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :swf
      t.string :height
      t.string :width
      t.string :videoID
      t.string :thumbnail
      t.string :type
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
