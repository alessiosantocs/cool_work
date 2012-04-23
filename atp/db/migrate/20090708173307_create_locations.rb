class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :city_id, :user_id, :event_id, :image_set_id, :party_id, :default => 0, :null => false
      t.boolean :there_now, :default => 1, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
