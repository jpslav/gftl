class InitSchema < ActiveRecord::Migration
  def self.up
    create_table "cars", :force => true do |t|
      t.string   "number"
      t.string   "icon_url"
      t.integer  "year"
      t.string   "normal_drivers"
      t.timestamps
    end

    create_table "draft_lists", :force => true do |t|
      t.integer  "user_id"
      t.string   "name"
      t.text     "notes"
      t.integer  "year"
      t.timestamps
    end

    create_table "draft_preferences", :force => true do |t|
      t.integer  "draft_list_id"
      t.integer  "car_id"
      t.integer  "rank"
      t.timestamps
    end

    create_table "league_memberships", :force => true do |t|
      t.integer  "league_id"
      t.integer  "owner_id"
      t.boolean  "is_administrator",     :default => false
      t.integer  "active_draft_list_id"
      t.timestamps
    end

    create_table "leagues", :force => true do |t|
      t.string   "name"
      t.integer  "year"
      t.integer  "max_owners"
      t.boolean  "is_registration_open", :default => true
      t.string   "password"
      t.timestamps
    end

    create_table "owned_stables", :force => true do |t|
      t.integer  "league_membership_id"
      t.integer  "car1_id"
      t.integer  "car2_id"
      t.timestamps
    end

    create_table "owners", :force => true do |t|
      t.string   "name"
      t.integer  "user_id"
      t.timestamps
    end

    create_table "preseason_rankings", :force => true do |t|
      t.integer  "car_id"
      t.integer  "year"
      t.integer  "ranking"
      t.timestamps
    end

    create_table "race_pairings", :force => true do |t|
      t.integer  "car_id"
      t.integer  "league_membership_id"
      t.integer  "race_id"
      t.integer  "preference_order"
      t.timestamps
    end

    create_table "race_results", :force => true do |t|
      t.integer  "car_id"
      t.integer  "race_id"
      t.integer  "points_delta"
      t.timestamps
    end

    create_table "race_stables", :force => true do |t|
      t.integer  "league_membership_id"
      t.integer  "race_id"
      t.integer  "car1_id"
      t.integer  "car2_id"
      t.integer  "car3_id"
      t.integer  "car4_id"
      t.integer  "car5_id"
      t.timestamps
    end

    create_table "races", :force => true do |t|
      t.datetime "racetime"
      t.string   "name"
      t.integer  "track_id"
      t.text     "notes"
      t.timestamps
    end

    create_table "sessions", :force => true do |t|
      t.string   "session_id", :null => false
      t.text     "data"
      t.timestamps
    end

    add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
    add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

    create_table "tracks", :force => true do |t|
      t.string   "name"
      t.string   "location"
      t.text     "notes"
      t.timestamps
    end

    create_table "users", :force => true do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.timestamps
        
      t.boolean  "is_administrator",             :default => false
      t.string   "first_name"
      t.string   "last_name"
      t.integer  "current_league_membership_id"
    end
    
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table "cars"
    drop_table "draft_lists"
    drop_table "draft_preferences"
    drop_table "league_memberships"
    drop_table "leagues"
    drop_table "owned_stables"
    drop_table "owners"
    drop_table "preseason_rankings"
    drop_table "race_pairings"
    drop_table "race_results"
    drop_table "race_stables"
    drop_table "races"
    drop_table "sessions"
    drop_table "tracks"
    drop_table "users"
  end
end
