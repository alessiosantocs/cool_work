class ChangePriceToPriceInCents < ActiveRecord::Migration
  def self.up
    change_column :items, :price, :integer
    change_column :items_orders, :price, :integer
    rename_column :items, :price, :price_in_cents
    rename_column :items_orders, :price, :price_in_cents
  end

  def self.down
    change_column :items, :price_in_cents, :float
    change_column :items_orders, :price_in_cents, :float
    rename_column :items, :price_in_cents, :price
    rename_column :items_orders, :price_in_cents, :price
  end
end
