class AddOrderStarch < ActiveRecord::Migration
  def self.up
    add_column :order_items, :ls_starch, :boolean
  end

  def self.down
    remove_column :order_items, :ls_starch
  end
end
