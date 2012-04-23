class AddExpressFlagToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :express, :boolean, :default => false
  end

  def self.down
    remove_column :orders, :express
  end
end
