class FixOrderItems < ActiveRecord::Migration
  def self.up
    add_column :order_items, :verified, :boolean, :default => false
    add_column :order_items, :status, :string
    add_column :order_items, :processed, :boolean
  end

  def self.down
    remove_column :order_items, :verified
    remove_column :order_items, :status
    remove_column :order_items, :processed
  end
end
