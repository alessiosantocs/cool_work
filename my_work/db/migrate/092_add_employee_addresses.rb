class AddEmployeeAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :employee_id, :integer
  end
  
  def self.down
    remove_column :addresses, :employee_id
  end
end
