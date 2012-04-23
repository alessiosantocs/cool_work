class AddDetailsToTruck < ActiveRecord::Migration
  def self.up
    add_column :trucks, :active, :boolean
    add_column :trucks, :rate_mod, :integer
    add_column :trucks, :decommissioned, :boolean, :default => false
  end

  def self.down
    remove_column :trucks, :active
    remove_column :trucks, :rate_mod
    remove_column :trucks, :decommissioned 
  end
end
