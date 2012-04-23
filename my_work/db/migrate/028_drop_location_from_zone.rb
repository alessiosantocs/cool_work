class DropLocationFromZone < ActiveRecord::Migration
  def self.up
    remove_column :zones, :location
  end

  def self.down
    add_column :zones, :location, :integer
  end
end
