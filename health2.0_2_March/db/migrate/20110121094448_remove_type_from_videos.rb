class RemoveTypeFromVideos < ActiveRecord::Migration
  def self.up
    remove_column :videos, :type
  end

  def self.down
    add_column :videos, :type, :string
  end
end
