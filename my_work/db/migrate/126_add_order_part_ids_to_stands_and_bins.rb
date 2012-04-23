class AddOrderPartIdsToStandsAndBins < ActiveRecord::Migration
  def self.up
    add_column :stands, :order_part_id, :integer
  end

  def self.down
    remove_column :stands, :order_part_id
  end
end
