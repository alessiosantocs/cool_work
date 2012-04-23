class CreatePromotionServices < ActiveRecord::Migration
  def self.up
    create_table :promotion_services do |t|
      t.integer :promotion_id
      t.integer :service_id
      t.integer :item_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :promotion_services
  end
end
