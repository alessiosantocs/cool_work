class DecoupleShiftsAndDays < ActiveRecord::Migration
  def self.up
    remove_column :shifts, :day_of_week
    remove_column :shifts, :day_mask
    remove_column :shifts, :day
  end

  def self.down
    add_column :shifts, :day_of_week, :string, :limit => 10
    add_column :shifts, :day_mask, :string, :limit => 7
    add_column :shifts, :day, :date
  end
end
