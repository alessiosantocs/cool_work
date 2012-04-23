class AddPremiumPriceToService < ActiveRecord::Migration
  def self.up
    change_column :prices, :premium, :decimal, :precision => 9, :scale => 2
  end

  def self.down
    change_column :prices, :premium, :boolean, :default => false
  end
end
