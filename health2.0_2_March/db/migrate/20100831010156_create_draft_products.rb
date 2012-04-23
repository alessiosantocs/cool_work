class CreateDraftProducts < ActiveRecord::Migration
  def self.up
    create_table :draft_products do |t|
      t.string :name
      t.text :description
      t.date :date_launched

      t.timestamps
    end
  end

  def self.down
    drop_table :draft_products
  end
end
