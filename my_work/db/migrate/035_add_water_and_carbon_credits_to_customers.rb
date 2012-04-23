class AddWaterAndCarbonCreditsToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :carbon_credits, :float
    add_column :customers, :water_credits, :float
  end

  def self.down
    remove_column :customers, :carbon_credits
    remove_column :customers, :water_credits
  end
end
