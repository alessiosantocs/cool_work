class AddPositionFunctions < ActiveRecord::Migration
  def self.up
    add_column :order_items, :position, :integer
    add_column :order_items, :destination, :integer
    add_column :bins, :position, :integer
    add_column :bins, :destination, :integer
    add_column :order_parts, :position, :integer
    add_column :order_parts, :destination, :integer
  end

  def self.down
    remove_column :order_items, :position
    remove_column :order_items, :destination
    remove_column :bins, :position
    remove_column :bins, :destination
    remove_column :order_parts, :position
    remove_column :order_parts, :destination
  end
end
