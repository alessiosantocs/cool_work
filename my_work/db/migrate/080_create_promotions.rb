class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.string :code, :function, :arguments
      t.column :times_usable, :integer, :default => 1
      t.date :expiry
      t.timestamps
    end
    add_column :orders, :promotion_id, :integer
    add_column :orders, :discount, :decimal, :precision => 9, :scale => 2, :default => 0.0
    add_column :orders, :points_used, :integer, :default => 0
  end

  def self.down
    drop_table :promotions
    remove_column :orders, :promotion_id
    remove_column :orders, :discount
    remove_column :orders, :points_used
  end
end
