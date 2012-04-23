class CreatePromotionZips < ActiveRecord::Migration
  def self.up
    create_table :promotion_zips do |t|
      t.integer :promotion_id
      t.integer :serviced_zip_id

      t.timestamps
    end
  end

  def self.down
    drop_table :promotion_zips
  end
end
