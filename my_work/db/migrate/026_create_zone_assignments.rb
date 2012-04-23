class CreateZoneAssignments < ActiveRecord::Migration
  def self.up
    create_table "zone_assignments" do |t|
      t.integer :zone_id
      t.integer :location_id
    end
  end

  def self.down
    drop_table :zone_assignments
  end
end
