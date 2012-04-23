class AddMovedToImagesTable < ActiveRecord::Migration
  # @@t1 = [:ads, :cover_images, :flyers, :stats]
  def self.up
    # add_column :images, :moved, :boolean
    # rename_column :events, :image_sets_count, :photos_count
    # rename_column :events, :picture_uploaded, :photo_uploaded
    # rename_column :events, :picture_upload_time, :photo_upload_time
    # @@t1.each { |t| add_column t, :medium_id, :integer }
  end

  def self.down
    # remove_column :images, :moved
    # rename_column :events, :photos_count, :image_sets_count
    # rename_column :events, :photo_uploaded, :picture_uploaded
    # rename_column :events, :photo_upload_time, :picture_upload_time
    # @@t1.each { |t| remove_column t, :medium_id }
  end
end
