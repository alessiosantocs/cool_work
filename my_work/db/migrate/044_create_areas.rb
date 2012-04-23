class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.integer :factory_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :areas
  end
end
