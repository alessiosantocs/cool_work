class DropColumsFromImages < ActiveRecord::Migration
  def self.up
    remove_column "images", "size"
    remove_column "images", "height"
    remove_column "images", "width"
    remove_column "images", "extension"
    remove_column "images", "parent_id"
  end

  def self.down
    add_column "images", "size", :integer, :limit => 10
    add_column "images", "height", :integer, :limit => 4
    add_column "image", "width", :integer, :limit => 4
    add_column "image", "extension", :string, :limit => 12
    add_column "image", "parent_id", :integer, :limit => 10
  end
end
