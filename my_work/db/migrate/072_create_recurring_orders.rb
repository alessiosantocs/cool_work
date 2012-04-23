class CreateRecurringOrders < ActiveRecord::Migration
  def self.up
    create_table :recurring_orders do |t|
      t.integer :address_id, :pickup_time, :delivery_time, :interval #pickup_time and delivery_time are regular windows, interval = weekly/every two weeks/...?
      t.string :pickup_day, :delivery_day
      t.timestamps
    end
    
    add_column :orders, :recurring, :boolean, :default => false
  end

  def self.down
    drop_table :recurring_orders
    
    remove_column :orders, :recurring
  end
end
