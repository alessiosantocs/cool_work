class CreateOrderParts < ActiveRecord::Migration
  def self.up
    create_table :order_parts do |t|
      t.integer :order_id, :service_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :order_parts
  end
end
