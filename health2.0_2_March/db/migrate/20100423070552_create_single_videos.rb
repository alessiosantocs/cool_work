class CreateSingleVideos < ActiveRecord::Migration
  def self.up
    create_table :single_videos do |t|
      t.text :code
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :single_videos
  end
end
