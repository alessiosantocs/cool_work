class AddEmployeeDetails < ActiveRecord::Migration
  def self.up
    add_column :employees, :home, :string, :limit => 10
    add_column :employees, :cell, :string, :limit => 10 
  end
  
  def self.down
    remove_column :employees, :home
    remove_column :employees, :cell
  end
end
