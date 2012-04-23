class AddTaxToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :finalized, :boolean
    add_column :orders, :tax, :decimal, :precision => 9, :scale => 2
    add_column :orders, :carbon_cost, :decimal, :precision => 9, :scale => 2
    add_column :orders, :water_cost, :decimal, :precision => 9, :scale => 2
    add_column :orders, :point_value, :integer
    change_column :customers, :points, :integer, :default => 0
  end

  def self.down
    remove_column :orders, :finalized
    remove_column :orders, :tax
    remove_column :orders, :carbon_cost
    remove_column :orders, :water_cost
    remove_column :orders, :point_value
    change_column :customers, :points, :integer
  end
end
