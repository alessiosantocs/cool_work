class AddAssignmentPosition < ActiveRecord::Migration
  def self.up
    add_column :assignments, :position, :integer, :limit => 2
  end

  def self.down
    remove_column :assignments, :position
  end
end
