class FixShifts < ActiveRecord::Migration
  #need to determine better means of modelling recurring shifts
  def self.up
    add_column :shifts, :day_mask, :string, :limit => 7
    add_column :shifts, :regular, :boolean, :default => false
  end

  def self.down
    remove_column :shifts, :day_mask
    remove_column :shifts, :regular
  end
end
