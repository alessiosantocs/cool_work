class AddRecurringOrderIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :recurring_order_id, :integer
  end

  def self.down
    remove_column :orders, :recurring_order_id
  end
end
