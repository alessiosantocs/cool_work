class AddTrackingNumberToCustomerItem < ActiveRecord::Migration
  def self.up
    add_column :customer_items, :tracking_number, :string
  end

  def self.down
    remove_column :customer_items, :tracking_number
  end
end
