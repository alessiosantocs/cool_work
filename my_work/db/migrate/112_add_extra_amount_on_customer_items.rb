class AddExtraAmountOnCustomerItems < ActiveRecord::Migration
  def self.up
    add_column :customer_items, :extra_charge, :decimal, :precision => 9, :scale => 2, :default => 0.0
    add_column :customer_items, :extra_charge_description, :string
  end

  def self.down
    remove_column :customer_items, :extra_charge
    remove_column :customer_items, :extra_charge_description
  end
end
