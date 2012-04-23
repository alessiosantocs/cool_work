class AddOtherMetricsToPrice < ActiveRecord::Migration
  def self.up
    add_column :prices, :water, :decimal, :precision => 9, :scale => 2
    add_column :prices, :carbon, :decimal, :precision => 9, :scale => 2
    add_column :prices, :point_value, :integer
    add_column :order_items, :water_cost, :decimal, :precision => 9, :scale => 2
    add_column :order_items, :carbon_cost, :decimal, :precision => 9, :scale => 2
    add_column :order_items, :point_value, :integer
  end

  def self.down
    remove_column :prices, :water
    remove_column :prices, :carbon
    remove_column :prices, :point_value
    remove_column :order_items, :water_cost
    remove_column :order_items, :carbon_cost
    remove_column :order_items, :point_value
  end
end
