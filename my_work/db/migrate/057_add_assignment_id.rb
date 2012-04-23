class AddAssignmentId < ActiveRecord::Migration
  def self.up
    add_column :requests, :assignment_id, :integer
  end
  
  def self.down
    remove_column :requests, :assignment_id
  end
end
