class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table "orders" do |t|
      t.column :customer_id, :integer
      t.column :count, :integer
      
      t.column :pickup_time, :integer
      t.column :pickup_address, :integer
      t.column :delivery_time, :integer
      t.column :delivery_address, :integer
      t.column :shipping, :decimal, :precision => 6, :scale => 2
      t.column :delivery_type, :integer
      
      t.timestamps
    end
  end

  def self.down
    drop_table "orders"
  end
end