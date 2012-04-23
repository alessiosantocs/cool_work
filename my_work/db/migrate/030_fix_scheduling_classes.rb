class FixSchedulingClasses < ActiveRecord::Migration
  def self.up
    rename_table "shifts", "windows"
            
    #linking table for windows-stops habtm
    create_table :stops_windows, :id => false do |t|
      t.column :window_id, :integer, :null => false
      t.column :stop_id, :integer, :null => false
    end
            
    remove_column :windows, :recurring
            
    remove_column :stops, :arrive
    remove_column :stops, :depart
    remove_column :stops, :day_mask
    add_column :stops, :slots, :integer
    add_column :stops, :date, :date
    add_column :stops, :complete, :boolean
            
    remove_column :routes, :truck_id
    add_column :routes, :recurring, :boolean
    add_column :routes, :mission, :string
    add_column :routes, :interval, :integer
    add_column :routes, :discontinue_on, :date
    add_column :routes, :recur_in_advance, :integer
    add_column :routes, :complete, :boolean, :default => false
    
    remove_column :assignments, :location_id
    remove_column :assignments, :zone_id
    remove_column :assignments, :date
    remove_column :assignments, :shift_id
    remove_column :assignments, :mission
    remove_column :assignments, :operating_day_id
    add_column :assignments, :route_id, :integer
    
    drop_table "operating_days"
  end

  def self.down
    rename_table "windows", "shifts"
    
    drop_table "stops_windows"
    
    add_column :shifts, :recurring, :boolean
    
    add_column :stops, :arrive, :time
    add_column :stops, :depart, :time
    add_column :stops, :day_mask, :string, :limit => 7
    remove_column :stops, :slots
    remove_column :stops, :date
    remove_column :stops, :complete
    
    add_column :routes, :truck_id, :integer
    remove_column :routes, :recurring
    remove_column :routes, :mission
    remove_column :routes, :interval
    remove_column :routes, :discontinue_on
    remove_column :routes, :recur_in_advance
    remove_column :routes, :complete
    
    
    add_column :assignments, :location_id, :integer
    add_column :assignments, :zone_id, :integer
    add_column :assignments, :date, :date
    add_column :assignments, :shift_id, :integer
    add_column :assignments, :mission, :string
    add_column :assignments, :operating_day_id, :integer
    remove_column :assignments, :route_id
    
    create_table "operating_days" do |t|
      t.column :date, :date
      t.column :rate_mod, :integer
    end
  end
end
