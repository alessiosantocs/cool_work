class RenameContainerNumberToTrackingNumber < ActiveRecord::Migration
  def self.up
    rename_column :bins, :number, :tracking_number
    rename_column :racks, :number, :tracking_number
    add_column :order_parts, :tracking_number, :integer
    add_column :order_items, :bin_id, :integer
    add_column :order_items, :rack_id, :integer
    add_column :order_items, :order_part_id, :integer
  end

  def self.down
    rename_column :bins, :tracking_number, :number
    rename_column :racks, :tracking_number, :number
    remove_column :order_parts, :tracking_number
    remove_column :order_items, :bin_id
    remove_column :order_items, :rack_id
    remove_column :order_items, :order_part_id
  end
end
