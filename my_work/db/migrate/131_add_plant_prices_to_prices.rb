class AddPlantPricesToPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :plant_price, :decimal, :precision => 9, :scale => 2, :default => 0.0
    add_column :prices, :plant_premium_price, :decimal, :precision => 9, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :prices, :plant_price
    remove_column :prices, :plant_premium_price
  end
end
