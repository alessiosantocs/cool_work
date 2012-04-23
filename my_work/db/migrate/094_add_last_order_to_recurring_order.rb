class AddLastOrderToRecurringOrder < ActiveRecord::Migration
  def self.up
    add_column :recurring_orders, :last_order_id, :integer
  end

  def self.down
    remove_column :recurring_orders, :last_order_id
  end
end
