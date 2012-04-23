class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.column "title", :string, :limit => 24
      t.column "user_id", :integer, :limit => 10
      t.column "image_id", :integer, :limit => 10
      t.column "size", :string, :limit => 7
      t.column "url", :string, :limit => 250
      t.column "start", :datetime
      t.column "stop", :datetime
      t.column "active", :boolean
      t.column "created_on", :datetime
    end
      
    create_table :zones do |t|
      t.column "name", :string, :limit => 24
      t.column "active", :boolean
      t.column "created_on", :datetime
    end
    
    #add some default zones
    ["FrontPage", "Party", "Image", "People", "Venue"].each { |z| Zone.create(:name => z, :active => true) }
    
    create_table :ads_cities, :id => false, :force => true do |t|
      t.column "ad_id", :integer, :limit => 10
      t.column "city_id", :integer, :limit => 3
    end
    
    create_table :ads_zones, :id => false, :force => true do |t|
      t.column "ad_id", :integer, :limit => 10
      t.column "zone_id", :integer, :limit => 3
    end
    
    add_index :ads, [:size, :active, :image_id, :user_id], :name => "idx_ads", :unique => false
    remove_column "flyers", "days_left"
  end

  def self.down
    add_column "flyers", "days_left", :integer, :limit => 3
    drop_table :ads_cities
    drop_table :ads_zones
    drop_table :zones
    drop_table :ads
  end
end
