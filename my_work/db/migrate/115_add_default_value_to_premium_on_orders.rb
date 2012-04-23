class AddDefaultValueToPremiumOnOrders < ActiveRecord::Migration
  def self.up
    change_column :orders, :premium, :boolean, :default => false
  end

  def self.down
    change_column :orders, :premium
  end
end
