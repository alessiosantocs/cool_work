class ChangeTrackingNumbersToStrings < ActiveRecord::Migration
  def self.up
    change_column :bins,        :tracking_number, :string
    change_column :racks,       :tracking_number, :string
    change_column :order_parts, :tracking_number, :string
  end

  def self.down
    change_column :bins,        :tracking_number, :integer
    change_column :racks,       :tracking_number, :integer
    change_column :order_parts, :tracking_number, :integer
  end
end
