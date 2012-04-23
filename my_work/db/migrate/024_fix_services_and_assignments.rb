class FixServicesAndAssignments < ActiveRecord::Migration
  def self.up
    add_column :services, :min_length, :integer, :null => false
    add_column :services, :rushable, :integer, :default => 0, :null => false
    add_column :assignments, :mission, :string
  end

  def self.down
    remove_column :services, :min_length
    remove_column :services, :rushable
    remove_column :assignments, :mission
  end
end
