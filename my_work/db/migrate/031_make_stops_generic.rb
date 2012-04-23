class MakeStopsGeneric < ActiveRecord::Migration
  def self.up
    remove_column :stops, :route_id
    add_column :stops, :window_id, :integer
  end

  def self.down
    add_column :stops, :route_id, :integer
    remove_column :stops, :window_id
  end
end
