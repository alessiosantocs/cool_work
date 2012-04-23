class AddInstructionsToOrders < ActiveRecord::Migration
  def self.up
    #also add processed boolean to order
    add_column :orders, :processed, :boolean
    add_column :orders, :instructions_id, :integer
    add_column :orders, :tracking_number, :string
  end

  def self.down
    remove_column :orders, :processed
    remove_column :orders, :instructions_id
    remove_column :orders, :tracking_number
  end
end
