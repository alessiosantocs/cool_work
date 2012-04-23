class AddIsActiveToPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :is_active, :boolean, :default => true
  end

  def self.down
    remove_column :prices, :is_active
  end
end
