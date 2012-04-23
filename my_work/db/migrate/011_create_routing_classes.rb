class CreateRoutingClasses < ActiveRecord::Migration
  def self.up
    #routes are chains of locations that are regularly serviced
    create_table "routes" do |t|
      t.column :truck_id, :integer
    end
    
    create_table "stops" do |t|
      t.column :route_id, :integer
      t.column :location_id, :integer
      t.column :arrive, :time
      t.column :depart, :time
      t.column :day_mask, :string, :limit => 7
    end
    
    create_table "trucks" do |t|
      t.column :name, :string
      t.column :capacity, :integer
    end
    
    create_table "drivers" do |t|
      t.column :user_id, :integer
    end
    
    create_table "assignments" do |t|
      t.column :driver_id, :integer
      t.column :route_id, :integer
      t.column :zone_id, :integer
      t.column :date, :date
    end
  end

  def self.down
    drop_table "assignments"
    drop_table "drivers"
    drop_table "trucks"
    drop_table "zones"
    drop_table "stops"
    drop_table "routes"
  end
end