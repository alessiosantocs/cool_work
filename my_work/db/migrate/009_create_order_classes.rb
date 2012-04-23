class CreateOrderClasses < ActiveRecord::Migration
  def self.up
    create_table "customer_items" do |t|
      t.column :customer_id, :integer
      t.column :item_type_id, :integer
      t.column :brand, :string
      t.column :color, :string
      t.column :value, :decimal, :precision => 9, :scale => 2
      t.column :material, :string
      
      t.column :service_id, :integer
      t.column :instructions_id, :integer
    end
    create_table "order_items" do |t|
      t.column :order_id, :integer
      t.column :customer_item_id, :integer
      t.column :service_id, :integer
      t.column :instructions_id, :integer
    end
    create_table "instructions" do |t|
      t.column :text, :text
    end
    create_table "item_types" do |t|
      t.column :name, :string
      t.column :icon, :string
    end
  end

  def self.down
    drop_table "item_types"
    drop_table "instructions"
    drop_table "order_items"
    drop_table "customer_items"
  end
end