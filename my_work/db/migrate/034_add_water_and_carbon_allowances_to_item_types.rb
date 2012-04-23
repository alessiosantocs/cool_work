class AddWaterAndCarbonAllowancesToItemTypes < ActiveRecord::Migration
  def self.up
    add_column :item_types, :carbon_cost, :float
    add_column :item_types, :water_cost, :float
  end

  def self.down
    remove_column :item_types, :carbon_cost
    remove_column :item_types, :water_cost
  end
end
