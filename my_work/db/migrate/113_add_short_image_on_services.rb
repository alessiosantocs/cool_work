class AddShortImageOnServices < ActiveRecord::Migration
  def self.up
    add_column :services, :short_image_url, :string
  end

  def self.down
    remove_column :services, :short_image_url, :string
  end
end
