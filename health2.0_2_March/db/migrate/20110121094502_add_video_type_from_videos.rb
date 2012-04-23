class AddVideoTypeFromVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :video_type, :string
  end

  def self.down
    remove_column :videos, :video_type
  end
end
