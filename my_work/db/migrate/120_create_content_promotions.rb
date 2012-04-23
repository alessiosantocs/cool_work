class CreateContentPromotions < ActiveRecord::Migration
  def self.up
    create_table :content_promotions do |t|
      t.string :title
      t.text :body
      t.datetime :expiry_date
      t.integer :promotion_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :content_promotions
  end
end
