class UpdateOrderModel < ActiveRecord::Migration
  def self.up
    remove_column :orders, :pickup_time
    remove_column :orders, :pickup_address
    remove_column :orders, :delivery_time
    remove_column :orders, :delivery_address
    add_column :orders, :status, :string
  end

  def self.down
    add_column :orders, :pickup_time, :integer
    add_column :orders, :pickup_address, :integer
    add_column :orders, :delivery_time, :integer
    add_column :orders, :delivery_address, :integer
    remove_column :orders, :status
  end
end
