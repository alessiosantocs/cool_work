class RenameRozToLocation < ActiveRecord::Migration
  def self.up
    rename_table :route_or_zone, :locations
    rename_column :locations, :roz_id, :target_id
    rename_column :locations, :roz_type, :target_type
    rename_column :assignments, :route_id, :location_id
  end

  def self.down
    rename_table :locations, :route_or_zone
    rename_column :route_or_zone, :target_id, :roz_id
    rename_column :route_or_zone, :target_type, :roz_type
    rename_column :assignments, :location_id, :route_id
  end
end
