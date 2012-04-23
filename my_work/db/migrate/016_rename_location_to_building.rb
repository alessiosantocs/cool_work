class RenameLocationToBuilding < ActiveRecord::Migration
  def self.up
    rename_table :locations, :buildings
    rename_column :addresses, :location_id, :building_id 
  end

  def self.down
    rename_column :addresses, :building_id, :location_id
    rename_table :buildings, :locations
  end
end
