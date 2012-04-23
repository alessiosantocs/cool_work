class AddTemporalityToAssignments < ActiveRecord::Migration
  def self.up
    create_table "shifts" do |t|
      t.column :start, :time
      t.column :end, :time
      t.column :day, :date
      t.column :recurring, :boolean
      t.column :day_of_week, :string, :limit => 10
    end
    
    add_column :assignments, :shift_id, :integer
    add_column :assignments, :truck_id, :integer
    
    create_table "route_or_zone" do |t|
      t.column :roz_id, :integer
      t.column :roz_type, :string
    end
  end

  def self.down
    drop_table "shifts"
    remove_column :assignments, :shift_id
    remove_column :assignments, :truck_id
    drop_table "route_or_zone"
  end
end
