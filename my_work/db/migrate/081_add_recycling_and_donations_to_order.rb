class AddRecyclingAndDonationsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :recycling, :boolean, :default => false
    add_column :orders, :clothing_donation, :boolean, :default => false
  end

  def self.down
    remove_column :orders, :recycling
    remove_column :orders, :clothing_donation
  end
end
