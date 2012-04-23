class AddWithDoormanToRequests < ActiveRecord::Migration
  def self.up
    add_column :requests, :with_doorman, :boolean, :default => false
  end

  def self.down
    remove_column :requests, :with_doorman
  end
end
