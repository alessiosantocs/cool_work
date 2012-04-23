class CreateStands < ActiveRecord::Migration
  def self.up
    create_table :stands do |t|
      t.string :name
      t.integer :area_id, :position, :destination, :number
      t.timestamps
    end
  end

  def self.down
    drop_table :stands
  end
end
