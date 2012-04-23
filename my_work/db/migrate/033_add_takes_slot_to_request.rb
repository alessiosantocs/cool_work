class AddTakesSlotToRequest < ActiveRecord::Migration
  def self.up
    add_column :requests, :takes_slot, :boolean
  end

  def self.down
    remove_column :requests, :takes_slot
  end
end
