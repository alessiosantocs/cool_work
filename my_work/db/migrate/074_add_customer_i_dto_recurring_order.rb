class AddCustomerIDtoRecurringOrder < ActiveRecord::Migration
  def self.up
    add_column :recurring_orders, :customer_id, :integer
  end

  def self.down
    remove_column :recurring_orders, :customer_id
  end
end
