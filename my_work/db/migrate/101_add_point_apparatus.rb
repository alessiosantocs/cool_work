class AddPointApparatus < ActiveRecord::Migration
  def self.up
    add_column :customers, :fresh_cash, :decimal, :precision => 6, :scale => 2, :default => 0.0
    add_column :orders, :points_awarded, :boolean, :default => false
  end

  def self.down
    remove_column :customers, :fresh_cash
    remove_column :orders, :points_awarded
  end
end
