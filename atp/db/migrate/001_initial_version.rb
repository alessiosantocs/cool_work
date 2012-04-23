require 'faster_csv'
SETTING = YAML::load(File.open("./config/settings.yml"))
class InitialVersion < ActiveRecord::Migration
  def self.up
    create_table "billing_profiles", :force => true do |t|
      t.column "user_id", :integer, :limit => 10
      t.column "title", :string, :limit => 25
      t.column "full_name", :string, :limit => 75
      t.column "address", :string, :limit => 75
      t.column "city", :string, :limit => 25
      t.column "state", :string, :limit => 25
      t.column "country", :string, :limit => 2
      t.column "postal_code", :string, :limit => 10
      t.column "phone", :string, :limit => 15
      t.column "primary_profile", :boolean
      t.column "last_4_numbers", :integer, :limit => 4
      t.column "created_on", :datetime
    end
  
    create_table "bookings", :force => true do |t|
      t.column "party_id", :integer
      t.column "user_id", :integer
      t.column "party_type", :integer, :limit => 2
      t.column "size", :integer, :limit => 4
      t.column "party_date", :date
      t.column "contact_date", :datetime
      t.column "contact_name", :string, :limit => 45
      t.column "contact_email", :string, :limit => 45
      t.column "contact_phone", :string, :limit => 15
      t.column "bottle_service", :boolean
      t.column "open_bar", :boolean
      t.column "catering", :boolean
      t.column "car_service", :boolean
      t.column "budget", :integer, :limit => 6
      t.column "notes", :text
      t.column "resolved", :boolean
      t.column "resolved_on", :datetime
      t.column "created_on", :datetime
    end
  
    create_table "cities", :force => true do |t|
      t.column "short_name", :string, :limit => 3
      t.column "full_name", :string, :limit => 25
      t.column "region_id", :integer, :limit => 10
      t.column "active", :boolean
    end
  
    create_table "comments", :force => true do |t|
      t.column "title", :string, :limit => 50, :default => ""
      t.column "comment", :string, :default => ""
      t.column "created_at", :datetime, :null => false
      t.column "commentable_id", :integer, :default => 0, :null => false
      t.column "commentable_type", :string, :limit => 15, :default => "", :null => false
      t.column "user_id", :integer, :default => 0, :null => false
      t.column "parent_id", :integer
    end
  
    add_index "comments", ["user_id"], :name => "fk_comments_user"
  
    create_table "confessions", :force => true do |t|
      t.column "user_id", :integer, :limit => 10
      t.column "name", :string, :limit => 30
      t.column "title", :string, :limit => 45
      t.column "location", :string, :limit => 45
      t.column "story", :text
      t.column "published", :boolean
      t.column "created_on", :date
    end
  
    create_table "cover_images", :force => true do |t|
      t.column "site_id", :integer, :limit => 10
      t.column "image_id", :integer, :limit => 10
      t.column "active", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "city_id", :integer, :limit => 10
    end
  
    create_table "events", :force => true do |t|
      t.column "party_id", :integer, :limit => 10
      t.column "venue_id", :integer, :limit => 10
      t.column "happens_at", :datetime
      t.column "search_date", :date
      t.column "comments_allowed", :boolean
      t.column "photographer_id", :integer, :limit => 10
      t.column "hosted_by", :string, :limit => 75
      t.column "synopsis", :text
      t.column "active", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "image_sets_count", :integer, :limit => 3
      t.column "picture_uploaded", :boolean
      t.column "picture_upload_time", :datetime
    end
  
    create_table "flags", :force => true do |t|
      t.column "user_id", :integer
      t.column "obj_type", :string, :limit => 24
      t.column "obj_id", :integer
      t.column "inappropriate", :boolean
      t.column "spam", :boolean
      t.column "resolved", :boolean
      t.column "created_on", :datetime
    end
  
    add_index "flags", ["user_id", "obj_type", "obj_id"], :name => "idx_flags"
  
    create_table "flyers", :force => true do |t|
      t.column "obj_type", :string, :limit => 12
      t.column "obj_id", :integer, :limit => 10
      t.column "image_id", :integer, :limit => 10
      t.column "days_left", :integer, :limit => 3
      t.column "active", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
  
    create_table "guestlists", :force => true do |t|
      t.column "event_id", :integer, :limit => 10
      t.column "user_id", :integer, :limit => 10
      t.column "full_name", :string, :limit => 45
      t.column "number_of_guests", :integer, :limit => 3
      t.column "created_on", :datetime
    end
  
    create_table "image_sets", :force => true do |t|
      t.column "obj_type", :string, :limit => 12
      t.column "obj_id", :integer, :limit => 10
      t.column "image_id", :integer, :limit => 10
      t.column "position", :integer, :limit => 3
      t.column "comments_allowed", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
  
    create_table "images", :force => true do |t|
      t.column "user_id", :integer, :limit => 10
      t.column "server", :string, :limit => 25
      t.column "path", :string, :limit => 128
      t.column "name", :string, :limit => 24
      t.column "width", :integer, :limit => 4
      t.column "height", :integer, :limit => 4
      t.column "size", :integer, :limit => 10
      t.column "extension", :string, :limit => 12
      t.column "caption", :string, :limit => 75
      t.column "comments_allowed", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "parent_id", :integer
      t.column "url", :string, :limit => 128
    end
  
    create_table "items", :force => true do |t|
      t.column "name", :string, :limit => 30
      t.column "description", :text
      t.column "price", :float
      t.column "active", :boolean
      t.column "created_on", :datetime
      t.column "type", :string, :limit => 12
      t.column "event_id", :integer, :limit => 10
    end
  
    create_table "items_orders", :id => false, :force => true do |t|
      t.column "item_id", :integer, :limit => 10
      t.column "order_id", :integer, :limit => 10
      t.column "price", :float
      t.column "created_on", :date
      t.column "party_id", :integer, :limit => 10
      t.column "quantity", :integer, :limit => 4
    end
  
    create_table "missed_connections", :force => true do |t|
      t.column "user_id", :integer, :limit => 8
      t.column "party_id", :integer, :limit => 9
      t.column "venue_id", :integer, :limit => 9
      t.column "location", :string, :limit => 45
      t.column "title", :string, :limit => 45
      t.column "connection_type", :string, :limit => 2
      t.column "connection_date", :date
      t.column "published", :boolean
      t.column "story", :text
      t.column "created_on", :datetime
    end
  
    create_table "msgs", :force => true do |t|
      t.column "subject", :string, :limit => 128
      t.column "sender_id", :integer
      t.column "receiver_id", :integer
      t.column "message", :text
      t.column "parent_id", :integer
      t.column "deleted_by_sender", :boolean
      t.column "deleted_by_receiver", :boolean
      t.column "read_timestamp", :datetime
      t.column "created_on", :datetime
    end
  
    add_index "msgs", ["sender_id", "receiver_id", "deleted_by_sender"], :name => "idx_sen_rec_del"
  
    create_table "orders", :force => true do |t|
      t.column "user_id", :integer, :limit => 10
      t.column "full_name", :string, :limit => 45
      t.column "address", :string, :limit => 45
      t.column "city", :string, :limit => 25
      t.column "state", :string, :limit => 25
      t.column "postal_code", :string, :limit => 10
      t.column "country", :string, :limit => 2
      t.column "phone", :string, :limit => 15
      t.column "total", :float
      t.column "cc_type", :string, :limit => 4
      t.column "cc_last4", :string, :limit => 4
      t.column "payment_status", :string, :limit => 12
      t.column "void_confirmation_number", :string, :limit => 12
      t.column "ip_address", :string, :limit => 16
      t.column "response", :string, :limit => 12
      t.column "notes", :text
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "type", :string, :limit => 12
    end
  
    create_table "parties", :force => true do |t|
      t.column "city_id", :integer, :limit => 10
      t.column "user_id", :integer, :limit => 10
      t.column "venue_id", :integer, :limit => 10
      t.column "current_event_id", :integer, :limit => 10
      t.column "last_event_id", :integer, :limit => 10
      t.column "title", :string, :limit => 50
      t.column "hosted_by", :string, :limit => 50
      t.column "end_date", :datetime
      t.column "length_in_hours", :float
      t.column "dress_code", :integer, :limit => 1
      t.column "age_male", :integer, :limit => 1
      t.column "age_female", :integer, :limit => 1
      t.column "door_charge", :float
      t.column "guestlist_charge", :float
      t.column "dj", :string, :limit => 45
      t.column "music", :string, :limit => 125
      t.column "description", :text
      t.column "wotm", :integer, :limit => 1
      t.column "tf", :integer, :limit => 1
      t.column "timeframecount", :integer, :limit => 1
      t.column "recur", :string, :limit => 12
      t.column "dotw", :integer, :limit => 1
      t.column "pics_left", :integer, :limit => 3
      t.column "days_paid", :integer, :limit => 4
      t.column "females_free_until", :string, :limit => 8
      t.column "males_free_until", :string, :limit => 8
      t.column "females_reduced_until", :string, :limit => 8
      t.column "males_reduced_until", :string, :limit => 8
      t.column "photographer", :string, :limit => 65
      t.column "sponsored", :boolean
      t.column "sponsored_ad_id", :string, :limit => 25
      t.column "comments_allowed", :boolean
      t.column "premium", :boolean
      t.column "active", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "days_free", :integer, :limit => 3
    end
  
    create_table "parties_sites", :id => false, :force => true do |t|
      t.column "party_id", :integer, :limit => 10
      t.column "site_id", :integer, :limit => 10
      t.column "created_on", :date
    end
  
    create_table "postal_codes", :force => true do |t|
      t.column "ZipCode", :string, :limit => 5
      t.column "PrimaryRecord", :string, :limit => 1
      t.column "Population", :float, :default => 0.0
      t.column "HouseholdsPerZipCode", :float
      t.column "WhitePopulation", :float
      t.column "BlackPopulation", :float
      t.column "HispanicPopulation", :float
      t.column "PersonsPerHousehold", :float
      t.column "AverageHouseValue", :float
      t.column "IncomePerHousehold", :float
      t.column "Latitude", :float
      t.column "Longitude", :float
      t.column "Elevation", :float
      t.column "State", :string, :limit => 2
      t.column "StateFullName", :string, :limit => 35
      t.column "CityType", :string, :limit => 1
      t.column "CityAliasAbbreviation", :string, :limit => 13
      t.column "AreaCode", :string, :limit => 55
      t.column "City", :string, :limit => 35
      t.column "CityAliasName", :string, :limit => 35
      t.column "CountyName", :string, :limit => 45
      t.column "CountyFIPS", :string, :limit => 5
      t.column "StateFIPS", :string, :limit => 2
      t.column "TimeZone", :integer, :limit => 2
      t.column "DayLightSaving", :string, :limit => 1
      t.column "MSA", :string, :limit => 35
      t.column "PMSA", :string, :limit => 4
      t.column "CSA", :string, :limit => 3
      t.column "CBSA", :string, :limit => 5
      t.column "CBSA_Div", :string, :limit => 5
      t.column "CBSAType", :string, :limit => 5
      t.column "CBSAName", :string, :limit => 150
      t.column "MSAName", :string, :limit => 150
      t.column "PMSAName", :string, :limit => 150
      t.column "Region", :string, :limit => 10
      t.column "Division", :string, :limit => 20
      t.column "MailingName", :string, :limit => 1
    end
  
    add_index "postal_codes", ["ZipCode", "PrimaryRecord"], :name => "zip_prim"
  
    create_table "ratings", :force => true do |t|
      t.column "rating", :integer, :default => 0
      t.column "created_at", :datetime, :null => false
      t.column "rateable_type", :string, :limit => 15, :default => "", :null => false
      t.column "rateable_id", :integer, :default => 0, :null => false
      t.column "user_id", :integer, :default => 0, :null => false
    end
  
    add_index "ratings", ["user_id"], :name => "fk_ratings_user"
  
    create_table "regions", :force => true do |t|
      t.column "full_name", :string, :limit => 25
      t.column "active", :boolean
      t.column "short_name", :string, :limit => 3
    end
  
    create_table "regions_sites", :id => false, :force => true do |t|
      t.column "region_id", :integer, :limit => 10
      t.column "site_id", :integer, :limit => 10
      t.column "created_on", :date
    end
  
    create_table "roles", :force => true do |t|
      t.column "name", :string, :limit => 25
      t.column "active", :boolean
    end
  
    create_table "roles_users", :id => false, :force => true do |t|
      t.column "role_id", :integer, :limit => 10
      t.column "user_id", :integer, :limit => 10
      t.column "created_on", :date
    end
  
    create_table "services", :force => true do |t|
      t.column "user_id", :integer, :limit => 10
      t.column "business_name", :string, :limit => 45
      t.column "category_id", :integer, :limit => 3
      t.column "name", :string, :limit => 45
      t.column "email", :string, :limit => 50
      t.column "phone", :string, :limit => 15
      t.column "fax", :string, :limit => 15
      t.column "url", :string, :limit => 128
      t.column "address", :string, :limit => 50
      t.column "city", :string, :limit => 35
      t.column "state", :string, :limit => 30
      t.column "postal_code", :string, :limit => 12
      t.column "country", :string, :limit => 2
      t.column "description", :text
      t.column "image", :boolean
      t.column "published", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
  
    create_table "sessions", :force => true do |t|
      t.column "session_id", :string
      t.column "data", :text
      t.column "updated_at", :datetime
    end
  
    add_index "sessions", ["session_id"], :name => "sessions_session_id_index"
  
    create_table "settings", :force => true do |t|
      t.column "var", :string, :default => "", :null => false
      t.column "value", :text
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  
    create_table "sites", :force => true do |t|
      t.column "short_name", :string, :limit => 3
      t.column "full_name", :string, :limit => 25
      t.column "comments_allowed", :boolean
      t.column "url", :string, :limit => 128
      t.column "active", :boolean
    end
  
    create_table "taggings", :force => true do |t|
      t.column "tag_id", :integer
      t.column "taggable_id", :integer
      t.column "taggable_type", :string, :limit => 24
      t.column "user_id", :integer
    end
  
    create_table "tags", :force => true do |t|
      t.column "name", :string, :limit => 30
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  
    create_table "trackers", :force => true do |t|
      t.column "obj_type", :string, :limit => 12
      t.column "obj_id", :integer, :limit => 10
      t.column "user_id", :integer, :limit => 10
      t.column "created_on", :date
    end
  
    create_table "users", :force => true do |t|
      t.column "username", :string, :limit => 75
      t.column "email", :string, :limit => 65
      t.column "site_id", :integer, :limit => 5
      t.column "full_name", :string, :limit => 75
      t.column "company_name", :string, :limit => 75
      t.column "sex", :string, :limit => 1
      t.column "mobile", :string, :limit => 15
      t.column "postal_code", :string, :limit => 9
      t.column "country", :string, :limit => 2
      t.column "ip_address", :string, :limit => 16
      t.column "password_hash", :string, :limit => 32
      t.column "password_salt", :string, :limit => 5
      t.column "member_login_key", :string, :limit => 32
      t.column "location", :string, :limit => 45
      t.column "time_zone", :string, :limit => 45
      t.column "allow_admin_mails", :boolean
      t.column "email_messages_allowed", :boolean
      t.column "deleted", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "image_flag", :boolean
      t.column "image_id", :integer, :limit => 10
    end
  
    add_index "users", ["username"], :name => "username", :unique => true
    add_index "users", ["email"], :name => "email", :unique => true
  
    create_table "venues", :force => true do |t|
      t.column "name", :string, :limit => 45
      t.column "user_id", :integer, :limit => 10
      t.column "postal_code", :string, :limit => 12
      t.column "address", :string, :limit => 75
      t.column "cross_street", :string, :limit => 45
      t.column "city", :string, :limit => 45
      t.column "state", :string, :limit => 45
      t.column "country", :string, :limit => 2
      t.column "phone", :string, :limit => 15
      t.column "time_zone", :string, :limit => 45
      t.column "active", :boolean
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
  
    create_table "votes", :force => true do |t|
      t.column "vote", :boolean, :default => false
      t.column "created_at", :datetime, :null => false
      t.column "voteable_type", :string, :limit => 15, :default => "", :null => false
      t.column "voteable_id", :integer, :default => 0, :null => false
      t.column "user_id", :integer, :default => 0, :null => false
    end
    add_index "votes", ["user_id"], :name => "fk_votes_user"
    
    Region.create(:id=> 1, :full_name => "New York", :short_name => 'nyc', :active => true )
    Region.create(:id=> 2, :full_name => "Houston", :short_name => 'hou', :active => true )
    #"Regions created."
    City.create(:id=> 1, :short_name => "NYC", :full_name => "New York City", :region_id => 1, :active => true )
    City.create(:id=> 2, :short_name => "HOU", :full_name => "Houston", :region_id => 2, :active => true )
    #"Cities created."
    Role.create(:id=> 1, :name => "Super Admin", :active => true )
    Role.create(:id=> 2, :name => "Admin", :active => true )
    Role.create(:id=> 3, :name => "Promoter", :active => true )
    Role.create(:id=> 4, :name => "Photographer", :active => true )
    Role.create(:id=> 5, :name => "Moderator", :active => true )
    #"Roles created."
    atp = Site.create(:id=> 1, :short_name => "ATP", :full_name => "AllTheParties", :comments_allowed => true, :url => "alltheparties.com", :active => true )
    atp.regions << Region.find(:all)
    anc = Site.create(:id=> 2, :short_name => "ANC", :full_name => "AllNightclubs", :comments_allowed => true, :url => "allnightclubs.com", :active => true )
    anc.regions << Region.find(1)
    #"Sites created."
    Item.create(:id=> 1, :name => "Day Listing", :price => SETTING['price']['days'], :description => "List your event by the day", :active => true )
    Item.create(:id=> 2, :name => "Picture Set", :price => SETTING['price']['pics'], :description => "Upload pictures for your events", :active => true )
    Item.create(:id=> 3, :name => "Flyer Ad", :price => SETTING['price']['flyers'], :description => "Advertise your events using your flyers", :active => true )
    #Items created

    csv_file = './db/postal_code.csv'
    FasterCSV.foreach(csv_file, :headers => true ) { |row|  PostalCode.create(row.to_hash) }

    user = User.create({"created_on"=>"2006-11-05 10:55:06", "allow_admin_mails"=>"1", "postal_code"=>"10033", "site_id"=>"1", "email_messages_allowed"=>"1", "company_name"=>"FCG Media", "updated_on"=>"2006-11-05 10:55:06", "password_salt"=>"3w7Fh", "country"=>"us", "username"=>"joemocha", "image_flag"=>nil, "id"=>"1", "mobile"=>"917-674-5655", "sex"=>"m", "deleted"=>nil, "password_hash"=>"a76a074937d0093a3278e518780a6e34", "time_zone"=>"Eastern Time (US & Canada)", "member_login_key"=>"2659f120f24aa25e2c2ddb1b77531fb6", "image_id"=>nil, "full_name"=>nil, "location"=>"New York, NY", "ip_address"=>nil, "email"=>"sam@obukwelu.com"})
    user.roles << Role.find(1)
    user.roles << Role.find(3)
    user.roles << Role.find(4)
  end

  def self.down
    drop_table :ratings
    drop_table :roles_users
    drop_table :sessions
    drop_table :settings
    drop_table :parties_sites
    drop_table :regions_sites
    drop_table :billing_profiles
    drop_table :cities
    drop_table :comments
    drop_table :confessions
    drop_table :cover_images
    drop_table :events
    drop_table :flags
    drop_table :bookings
    drop_table :flyers
    drop_table :guestlists
    drop_table :image_sets
    drop_table :images
    drop_table :items
    drop_table :items_orders
    drop_table :msgs
    drop_table :missed_connections
    drop_table :orders
    drop_table :parties
    drop_table :regions
    drop_table :postal_codes
    drop_table :roles
    drop_table :services
    drop_table :sites
    drop_table :tags
    drop_table :taggings
    drop_table :trackers
    drop_table :users
    drop_table :venues
    drop_table :votes
  end
end
