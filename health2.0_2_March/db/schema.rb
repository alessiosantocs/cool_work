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

ActiveRecord::Schema.define(:version => 20110208114719) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.date     "founded"
    t.integer  "employee_number"
    t.string   "market_segment"
    t.text     "description"
    t.text     "private_notes"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_companies", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.date     "founded"
    t.integer  "employee_number"
    t.string   "market_segment"
    t.text     "description"
    t.text     "private_notes"
    t.boolean  "enabled"
    t.integer  "draft_review_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_company_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_investments", :force => true do |t|
    t.string   "agency"
    t.integer  "funding_amount"
    t.string   "funding_type"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "funding_date"
  end

  create_table "draft_partnerships", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "draft_personnels", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "curent_title"
    t.string   "previous_title"
    t.boolean  "founder"
    t.string   "grad_edu"
    t.string   "undergrad_edu"
    t.string   "other_edu"
    t.text     "private_notes"
    t.integer  "company_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "current_title"
  end

  create_table "draft_products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "date_launched"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "draft_reviews", :force => true do |t|
    t.integer  "company_id"
    t.boolean  "accepted"
    t.boolean  "processed"
    t.integer  "email_tracker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_addresses", :force => true do |t|
    t.integer  "person_id"
    t.string   "email"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "template_name"
    t.text     "template_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_trackers", :force => true do |t|
    t.string   "message"
    t.string   "return_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
  end

  create_table "investments", :force => true do |t|
    t.integer  "company_id"
    t.string   "agency"
    t.integer  "funding_amount", :limit => 10, :precision => 10, :scale => 0
    t.date     "funding_date"
    t.string   "funding_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keyword_stores", :force => true do |t|
    t.text     "keywords"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_trackers", :force => true do |t|
    t.integer  "email_tracker_id"
    t.integer  "company_id"
    t.boolean  "answered"
    t.string   "url_key"
    t.boolean  "send_success"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partnerships", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personnels", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "current_title"
    t.string   "previous_title"
    t.boolean  "founder"
    t.string   "grad_edu"
    t.string   "undergrad_edu"
    t.string   "other_edu"
    t.text     "private_notes"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer  "person_id"
    t.string   "phone"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.date     "date_launched"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "profits", :force => true do |t|
    t.integer  "year"
    t.date     "date_launched"
    t.integer  "amount",        :limit => 10, :precision => 10, :scale => 0
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pwd_trackers", :force => true do |t|
    t.string   "email"
    t.string   "urlKey"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "references", :force => true do |t|
    t.text     "url"
    t.integer  "company_id"
    t.date     "dateEntered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "article_field_name"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "single_videos", :force => true do |t|
    t.text     "code"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_attributes", :force => true do |t|
    t.string   "name"
    t.integer  "User_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "login_count",       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "videos", :force => true do |t|
    t.string   "swf"
    t.string   "height"
    t.string   "width"
    t.string   "videoID"
    t.string   "thumbnail"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_type"
  end

end
