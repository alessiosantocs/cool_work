class AddOrderDonationsHangersPremium < ActiveRecord::Migration
  def self.up
    add_column :orders, :premium, :boolean
    add_column :orders, :donations, :boolean
    add_column :orders, :hangers, :boolean
  end

  def self.down
    remove_column :orders, :premium
    remove_column :orders, :donations
    remove_column :orders, :hangers
  end
end
