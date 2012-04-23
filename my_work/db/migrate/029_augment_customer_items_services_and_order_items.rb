class AugmentCustomerItemsServicesAndOrderItems < ActiveRecord::Migration
  def self.up
    add_column "customer_items", :is_temporary, :boolean
    add_column "order_items", :weight, :decimal, :precision => 6, :scale => 2, :default => 1.00
    add_column "services", :is_itemizeable, :boolean
    add_column "services", :is_detailable, :boolean
    add_column "services", :is_weighable, :boolean
    add_column "services", :area_of_availability, :integer
  end

  def self.down
    remove_column :customer_items, :is_temporary
    remove_column :order_items, :weight
    remove_column :services, :is_itemizeable
    remove_column :services, :is_detailable
    remove_column :services, :is_weighable
    remove_column :services, :area_of_availability
  end
end
