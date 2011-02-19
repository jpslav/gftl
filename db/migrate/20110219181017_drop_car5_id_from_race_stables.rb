class DropCar5IdFromRaceStables < ActiveRecord::Migration
  def self.up
    remove_column :race_stables, :car5_id
  end

  def self.down
    add_column :race_stables, :car5_id, :integer
  end
end
