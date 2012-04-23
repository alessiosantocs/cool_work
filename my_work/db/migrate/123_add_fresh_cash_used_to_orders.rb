class AddFreshCashUsedToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :fresh_cash_used, :decimal, :precision => 9, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :orders, :fresh_cash_used
  end
end
