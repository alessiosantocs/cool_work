class PushReferalToAccountLevelFromCustomer < ActiveRecord::Migration
  def self.up
    remove_column :customers, :referrer
    add_column :users, :referrer, :integer
  end

  def self.down
    remove_column :users, :referrer
    add_column :customers, :referrer, :integer
  end
end
