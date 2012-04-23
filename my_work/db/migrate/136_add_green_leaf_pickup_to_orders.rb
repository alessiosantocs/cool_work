class AddGreenLeafPickupToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :green_leaf_pickup, :integer
  end

  def self.down
    remove_column :orders, :green_leaf_pickup
  end
end
