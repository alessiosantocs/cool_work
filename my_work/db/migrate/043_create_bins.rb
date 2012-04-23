class CreateBins < ActiveRecord::Migration
  def self.up
    create_table :bins do |t|
      t.integer :order_part_id, :number, :area_id
      t.boolean :full
      t.timestamps
    end
  end

  def self.down
    drop_table :bins
  end
end
