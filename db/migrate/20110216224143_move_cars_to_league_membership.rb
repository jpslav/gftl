class MoveCarsToLeagueMembership < ActiveRecord::Migration
  def self.up
    add_column :league_memberships, :franchise_car_id, :integer
    add_column :league_memberships, :darkhorse_car_id, :integer

    drop_table :owned_stables
  end

  def self.down
    remove_column :league_memberships, :franchise_car_id
    remove_column :league_memberships, :darkhorse_car_id

    create_table "owned_stables", :force => true do |t|
      t.integer  "league_membership_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "franchise_car_id"
      t.integer  "darkhorse_car_id"
    end
  end
end
