class AddFreeShippingOption < ActiveRecord::Migration
  def self.up
    add_column :customers, :free_shipping, :boolean, :default => false
    add_column :orders,    :free_shipping, :boolean, :default => false
  end

  def self.down
    remove_column :orders, :free_shipping
    remove_column :customers, :free_shipping
  end
end
