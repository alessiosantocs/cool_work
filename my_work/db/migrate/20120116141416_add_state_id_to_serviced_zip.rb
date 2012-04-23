class AddStateIdToServicedZip < ActiveRecord::Migration
  def self.up
    add_column :serviced_zips, :state_id, :integer
  end

  def self.down
    remove_column :serviced_zips, :state_id
  end
end
