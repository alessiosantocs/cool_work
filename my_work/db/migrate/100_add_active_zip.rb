class AddActiveZip < ActiveRecord::Migration
  def self.up
    add_column :serviced_zips, :active, :boolean, :default => true
  end

  def self.down
    remove_column :serviced_zips, :active
  end
end
