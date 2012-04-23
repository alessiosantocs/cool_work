class AddBuildingCustomerInfrastructure < ActiveRecord::Migration
  def self.up
    add_column :customers, :is_building, :boolean, :default => false
  end

  def self.down
    remove_column :customers, :is_building
  end
end
