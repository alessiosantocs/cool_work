class ChangeRecurringOrderWdaysToIntegers < ActiveRecord::Migration
  def self.up
    change_column :recurring_orders, :pickup_day, :integer
    change_column :recurring_orders, :delivery_day, :integer
    add_column :recurring_orders, :starting_on, :date
  end

  def self.down
    change_column :recurring_orders, :pickup_day, :string
    change_column :recurring_orders, :delivery_day, :string
    remove_column :recurring_orders, :starting_on
  end
end
