class AddCustomerBuildingType < ActiveRecord::Migration
  def self.up
    add_column :customers, :building_type, :boolean, :default => false
    
    customers = Customer.find(:all)
    for customer in customers
      if !customer.company.blank?
        customer.building_type = true
        customer.save!
      end
    end
  end
  
  def self.down
    remove_column :customers, :building_type
  end
end
