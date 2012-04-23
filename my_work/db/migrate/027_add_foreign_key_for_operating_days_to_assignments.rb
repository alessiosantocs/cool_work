class AddForeignKeyForOperatingDaysToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :operating_day_id, :integer
  end

  def self.down
    remove_column :assignments, :operating_day_id
  end
end
