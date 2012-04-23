class AddSizeToCustomerItems < ActiveRecord::Migration
  def self.up
    add_column :customer_items, :size, :string, :limit => 10
  end

  def self.down
    remove_column :customer_items, :size
  end
end
