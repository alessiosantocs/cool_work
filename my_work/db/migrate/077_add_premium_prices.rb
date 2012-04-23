class AddPremiumPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :premium, :boolean, :default => false
  end

  def self.down
    remove_column :prices, :premium
  end
end
