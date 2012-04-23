# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120413085518) do

  create_table "addresses", :force => true do |t|
    t.string  "label",            :limit => 20
    t.integer "building_id"
    t.integer "customer_id"
    t.string  "unit_designation", :limit => 12
    t.string  "unit_number",      :limit => 8
    t.integer "employee_id"
  end

  create_table "areas", :force => true do |t|
    t.integer  "factory_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer "driver_id"
    t.integer "truck_id"
    t.string  "status",      :limit => 20
    t.date    "date"
    t.integer "location_id"
    t.integer "position"
  end

  create_table "assignments_windows", :force => true do |t|
    t.integer "assignment_id"
    t.integer "window_id"
  end

  create_table "bins", :force => true do |t|
    t.integer  "order_part_id"
    t.string   "tracking_number"
    t.integer  "area_id"
    t.boolean  "full"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "destination"
  end

  create_table "buildings", :force => true do |t|
    t.string  "addr1"
    t.string  "addr2"
    t.string  "city"
    t.string  "state"
    t.string  "zip",         :limit => 9
    t.boolean "doorman"
    t.integer "schedule_id"
    t.boolean "serviced"
  end

  create_table "content_promotions", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "expiry_date"
    t.integer  "promotion_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", :force => true do |t|
    t.text     "address"
    t.string   "phone"
    t.string   "email"
    t.string   "eco_value_1"
    t.string   "eco_value_2"
    t.string   "eco_value_3"
    t.string   "title"
    t.text     "body"
    t.string   "link"
    t.text     "link_text"
    t.string   "sub_title"
    t.text     "sub_body"
    t.string   "sub_link"
    t.text     "sub_link_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_card_infos", :force => true do |t|
    t.string   "card_number"
    t.string   "payment_card_method"
    t.integer  "order_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credit_card_id"
  end

  create_table "credit_cards", :force => true do |t|
    t.integer  "customer_id"
    t.string   "payment_method"
    t.string   "last_four_digits"
    t.string   "name"
    t.string   "payment_profile_id"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "building_id"
    t.string   "security_code"
  end

  create_table "customer_items", :force => true do |t|
    t.integer "customer_id"
    t.integer "item_type_id"
    t.string  "brand"
    t.string  "color"
    t.decimal "value",                                  :precision => 9, :scale => 2
    t.string  "material"
    t.integer "service_id"
    t.integer "instructions_id"
    t.string  "tracking_number"
    t.boolean "is_temporary"
    t.string  "size",                     :limit => 10
    t.boolean "premium"
    t.decimal "extra_charge",                           :precision => 9, :scale => 2, :default => 0.0
    t.string  "extra_charge_description"
    t.decimal "plant_extra_charge",                     :precision => 9, :scale => 2, :default => 0.0
    t.decimal "plant_price",                            :precision => 9, :scale => 2, :default => 0.0
  end

  create_table "customer_preferences", :force => true do |t|
    t.integer "customer_id"
    t.string  "wf_temperature"
    t.boolean "wf_fabric_softener"
    t.boolean "wf_bleach"
    t.boolean "ls_starch",           :default => true
    t.boolean "ls_press",            :default => true
    t.string  "ls_packaging"
    t.boolean "dc_starch",           :default => true
    t.boolean "dc_press",            :default => true
    t.boolean "permanent_tags"
    t.boolean "day_before_email"
    t.boolean "day_before_sms"
    t.boolean "day_of_email"
    t.boolean "day_of_sms"
    t.string  "preferred_contact"
    t.boolean "doorman_permission"
    t.boolean "my_fresh_water"
    t.boolean "my_fresh_air"
    t.boolean "wants_updates"
    t.boolean "wants_promotions"
    t.string  "email_format"
    t.boolean "wants_minor_repairs"
    t.boolean "promotion_email",     :default => true
  end

  create_table "customers", :force => true do |t|
    t.string   "title"
    t.string   "company"
    t.string   "sex",                   :limit => 1
    t.date     "dob"
    t.integer  "primary_address_id"
    t.string   "work",                  :limit => 10
    t.string   "home",                  :limit => 10
    t.string   "cell",                  :limit => 10
    t.boolean  "active"
    t.boolean  "accepted_terms"
    t.integer  "points",                                                            :default => 0
    t.datetime "created_on"
    t.datetime "updated_on"
    t.float    "carbon_credits"
    t.float    "water_credits"
    t.string   "work_extension",        :limit => 10
    t.boolean  "is_building",                                                       :default => false
    t.string   "authdotnet_profile_id"
    t.string   "goto_url"
    t.boolean  "free_shipping",                                                     :default => false
    t.decimal  "fresh_cash",                          :precision => 6, :scale => 2, :default => 0.0
    t.boolean  "building_type",                                                     :default => false
    t.string   "telephone_number"
  end

  create_table "drivers", :force => true do |t|
    t.integer "user_id"
  end

  create_table "employee_pay_outs", :force => true do |t|
    t.integer  "employee_id"
    t.decimal  "amount",        :precision => 9, :scale => 2
    t.integer  "authorized_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string "referral_code"
    t.string "home",          :limit => 10
    t.string "cell",          :limit => 10
  end

  create_table "instructions", :force => true do |t|
    t.text "text"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "send_reminder_email", :default => false
  end

  create_table "item_types", :force => true do |t|
    t.string "name"
    t.string "icon"
    t.float  "carbon_cost"
    t.float  "water_cost"
  end

  create_table "locations", :force => true do |t|
    t.integer "target_id"
    t.string  "target_type"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "order_id"
    t.integer  "customer_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note_type",   :default => "", :null => false
  end

  create_table "notification_templates", :force => true do |t|
    t.string   "name"
    t.text     "mail_body"
    t.text     "sms_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", :force => true do |t|
    t.integer "order_id"
    t.integer "customer_item_id"
    t.integer "service_id"
    t.integer "instructions_id"
    t.decimal "weight",           :precision => 6, :scale => 2, :default => 1.0
    t.boolean "verified"
    t.string  "status"
    t.boolean "processed"
    t.integer "position"
    t.integer "destination"
    t.decimal "price",            :precision => 9, :scale => 2
    t.decimal "water_cost",       :precision => 9, :scale => 2
    t.decimal "carbon_cost",      :precision => 9, :scale => 2
    t.integer "point_value"
    t.integer "bin_id"
    t.integer "rack_id"
    t.integer "order_part_id"
    t.boolean "premium"
    t.boolean "ls_starch"
  end

  create_table "order_parts", :force => true do |t|
    t.integer  "order_id"
    t.integer  "service_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "destination"
    t.string   "tracking_number"
  end

  create_table "order_products", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.decimal  "price",      :precision => 9, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "count"
    t.decimal  "shipping",            :precision => 6, :scale => 2
    t.integer  "delivery_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified"
    t.string   "status"
    t.decimal  "amount",              :precision => 8, :scale => 2
    t.boolean  "processed"
    t.integer  "instructions_id"
    t.string   "tracking_number"
    t.boolean  "recurring",                                         :default => false
    t.boolean  "finalized"
    t.decimal  "tax",                 :precision => 9, :scale => 2
    t.decimal  "carbon_cost",         :precision => 9, :scale => 2
    t.decimal  "water_cost",          :precision => 9, :scale => 2
    t.integer  "point_value"
    t.integer  "promotion_id"
    t.decimal  "discount",            :precision => 9, :scale => 2, :default => 0.0
    t.integer  "points_used",                                       :default => 0
    t.boolean  "recycling",                                         :default => false
    t.boolean  "clothing_donation",                                 :default => false
    t.boolean  "express",                                           :default => false
    t.boolean  "free_shipping",                                     :default => false
    t.boolean  "premium",                                           :default => false
    t.boolean  "donations"
    t.boolean  "hangers"
    t.boolean  "points_awarded",                                    :default => false
    t.decimal  "fresh_cash_used",     :precision => 9, :scale => 2, :default => 0.0
    t.integer  "recurring_order_id"
    t.integer  "eco_status"
    t.integer  "green_leaf_pickup"
    t.integer  "green_leaf_delivery"
  end

  create_table "payments", :force => true do |t|
    t.decimal  "amount",         :precision => 8, :scale => 2
    t.string   "transaction_id"
    t.string   "status"
    t.datetime "expiry"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credit_card_id"
  end

  create_table "prices", :force => true do |t|
    t.integer "item_type_id"
    t.integer "service_id"
    t.decimal "price",                    :precision => 6, :scale => 2
    t.decimal "water",                    :precision => 9, :scale => 2
    t.decimal "carbon",                   :precision => 9, :scale => 2
    t.integer "point_value"
    t.decimal "premium",                  :precision => 9, :scale => 2, :default => 0.0
    t.decimal "each_additional_standard", :precision => 9, :scale => 2, :default => 0.0
    t.decimal "each_additional_premium",  :precision => 9, :scale => 2, :default => 0.0
    t.boolean "is_active",                                              :default => true
    t.decimal "plant_price",              :precision => 9, :scale => 2, :default => 0.0
    t.decimal "plant_premium_price",      :precision => 9, :scale => 2, :default => 0.0
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price",       :precision => 9, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotion_services", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "service_id"
    t.integer  "item_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotion_zips", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "serviced_zip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotions", :force => true do |t|
    t.string   "code"
    t.string   "function"
    t.string   "arguments"
    t.integer  "times_usable",          :default => 1
    t.date     "expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "times_usable_per_user", :default => 1
  end

  create_table "racks", :force => true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.integer  "position"
    t.integer  "destination"
    t.string   "tracking_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_part_id"
  end

  create_table "recurring_orders", :force => true do |t|
    t.integer  "address_id"
    t.integer  "pickup_time"
    t.integer  "delivery_time"
    t.integer  "interval"
    t.integer  "pickup_day"
    t.integer  "delivery_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.date     "starting_on"
    t.integer  "last_order_id"
  end

  create_table "requests", :force => true do |t|
    t.string   "for"
    t.integer  "stop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "takes_slot"
    t.integer  "order_id"
    t.integer  "assignment_id"
    t.boolean  "with_doorman",  :default => false
  end

  add_index "requests", ["stop_id"], :name => "index_requests_on_stop_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "routes", :force => true do |t|
    t.boolean "recurring"
    t.string  "mission"
    t.integer "interval"
    t.date    "discontinue_on"
    t.integer "recur_in_advance"
    t.boolean "complete",         :default => false
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "serviced_zips", :force => true do |t|
    t.string  "zip",      :limit => 9
    t.boolean "active",                :default => true
    t.integer "state_id"
  end

  create_table "services", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "min_length",                                    :null => false
    t.integer "rushable",             :default => 0,           :null => false
    t.boolean "is_itemizeable"
    t.boolean "is_detailable"
    t.boolean "is_weighable"
    t.integer "area_of_availability"
    t.string  "image_url",            :default => "other.jpg"
    t.boolean "is_active",            :default => true
    t.string  "short_image_url"
  end

  create_table "stands", :force => true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.integer  "position"
    t.integer  "destination"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_part_id"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stops", :force => true do |t|
    t.integer "location_id"
    t.integer "slots"
    t.date    "date"
    t.boolean "complete"
    t.integer "window_id"
  end

  add_index "stops", ["date"], :name => "index_stops_on_date"
  add_index "stops", ["location_id"], :name => "index_stops_on_location_id"

  create_table "stops_windows", :id => false, :force => true do |t|
    t.integer "window_id", :null => false
    t.integer "stop_id",   :null => false
  end

  create_table "tickers", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.date     "expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucks", :force => true do |t|
    t.string  "name"
    t.integer "capacity"
    t.boolean "active"
    t.integer "rate_mod"
    t.boolean "decommissioned",              :default => false
    t.string  "hex_color",      :limit => 6, :default => "CC3333"
  end

  create_table "user_invitations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "login"
    t.string   "email"
    t.string   "remember_token"
    t.string   "maiden"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_token_expires_at"
    t.integer  "invitation_id"
    t.integer  "invitation_limit"
    t.integer  "invitation_max"
    t.integer  "invitation_count"
    t.string   "user_class",                :limit => 20
    t.integer  "account_id"
    t.string   "account_type"
    t.integer  "referrer"
  end

  create_table "windows", :force => true do |t|
    t.time    "start"
    t.time    "end"
    t.boolean "regular", :default => false
  end

  create_table "zone_assignments", :force => true do |t|
    t.integer "zone_id"
    t.integer "location_id"
  end

  create_table "zones", :force => true do |t|
    t.string "name"
  end

end
