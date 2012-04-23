class AddPlantExtraPricesToCustomerItems < ActiveRecord::Migration
  def self.up
    add_column :customer_items, :plant_extra_charge, :decimal, :precision => 9, :scale => 2, :default => 0.0
    add_column :customer_items, :plant_price, :decimal, :precision => 9, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :customer_items, :plant_extra_charge
    remove_column :customer_items, :plant_price
  end
end
