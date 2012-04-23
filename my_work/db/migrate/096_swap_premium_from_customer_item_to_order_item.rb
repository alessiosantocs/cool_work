class SwapPremiumFromCustomerItemToOrderItem < ActiveRecord::Migration
  def self.up
    add_column    :order_items,    :premium, :boolean
    #remove_column :customer_items, :premium
  end

  def self.down
    #add_column :customer_items, :premium, :boolean
    remove_column :order_items, :premium
  end
end
