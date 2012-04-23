class CreateOrderProducts < ActiveRecord::Migration
  def self.up
    create_table :order_products do |t|
      t.integer :order_id, :product_id, :quantity
      t.column :price, :decimal, :precision => 9, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :order_products
  end
end
