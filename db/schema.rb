# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110216224143) do

  create_table "cars", :force => true do |t|
    t.string   "number"
    t.string   "icon_url"
    t.integer  "year"
    t.string   "normal_drivers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "notes"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_preferences", :force => true do |t|
    t.integer  "draft_list_id"
    t.integer  "car_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "league_memberships", :force => true do |t|
    t.integer  "league_id"
    t.integer  "owner_id"
    t.boolean  "is_administrator",     :default => false
    t.integer  "active_draft_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "franchise_car_id"
    t.integer  "darkhorse_car_id"
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.integer  "year"
    t.integer  "max_owners"
    t.boolean  "is_registration_open", :default => true
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preseason_rankings", :force => true do |t|
    t.integer  "car_id"
    t.integer  "year"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_pairings", :force => true do |t|
    t.integer  "car_id"
    t.integer  "league_membership_id"
    t.integer  "race_id"
    t.integer  "preference_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_results", :force => true do |t|
    t.integer  "car_id"
    t.integer  "race_id"
    t.integer  "points_delta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_stables", :force => true do |t|
    t.integer  "league_membership_id"
    t.integer  "race_id"
    t.integer  "car1_id"
    t.integer  "car2_id"
    t.integer  "car3_id"
    t.integer  "car4_id"
    t.integer  "car5_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", :force => true do |t|
    t.datetime "racetime"
    t.string   "name"
    t.integer  "track_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                       :default => "",    :null => false
    t.string   "encrypted_password",           :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                               :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                               :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_administrator",                            :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "current_league_membership_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
