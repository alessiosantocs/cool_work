class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.date :date_launched
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
