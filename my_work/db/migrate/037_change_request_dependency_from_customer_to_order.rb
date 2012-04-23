class ChangeRequestDependencyFromCustomerToOrder < ActiveRecord::Migration
  def self.up
    remove_column :requests, :customer_id
    add_column :requests, :order_id, :integer
  end

  def self.down
    add_column :requests, :customer_id, :integer
    remove_column :requests, :order_id
  end
end
