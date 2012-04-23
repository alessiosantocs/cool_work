class AddPremiumToItems < ActiveRecord::Migration
  def self.up
    add_column :customer_items, :premium, :boolean
  end
  
  def self.down
    remove_column :customer_items, :premium
  end
end
