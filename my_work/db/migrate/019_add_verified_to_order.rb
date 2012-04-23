class AddVerifiedToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :verified, :boolean, :default => false
  end

  def self.down
    remove_column :orders, :verified
  end
end
