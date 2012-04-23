class AddEcoStatusToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :eco_status, :integer
  end

  def self.down
    remove_column :orders, :eco_status
  end
end
