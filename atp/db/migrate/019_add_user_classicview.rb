class AddUserClassicview < ActiveRecord::Migration
  def self.up
    add_column "users", "classic_view", :boolean, :default => false, :null => true
  end

  def self.down
    remove_column "users", "classic_view"
  end
end
