class UpdateAssignmentModels < ActiveRecord::Migration
  def self.up
    remove_column :assignments, :route_id
    add_column :assignments, :status, :string, :limit => 20
    add_column :assignments, :date, :date
    add_column :assignments, :location_id, :integer
    
    create_table :assignments_windows do |t|
      t.integer :assignment_id
      t.integer :window_id
    end
  end

  def self.down
    add_column :assignments, :route_id, :integer
    remove_column :assignments, :status
    remove_column :assignments, :date
    remove_column :assignments, :location_id
    
    drop_table :assignments_windows
  end
end
