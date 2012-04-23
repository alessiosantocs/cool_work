class AddGreenLeafDeliveryToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :green_leaf_delivery, :integer
  end

  def self.down
    remove_column :orders, :green_leaf_delivery
  end
end
