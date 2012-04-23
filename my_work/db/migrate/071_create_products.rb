class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      #max_orderable?, special?
      t.string :name
      t.text :description
      t.column :price, :decimal, :precision => 9, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
