class AddNumCarsPerStableToLeagues < ActiveRecord::Migration
  def self.up
    add_column :leagues, :num_cars_per_stable, :integer
  end

  def self.down
    remove_column :leagues, :num_cars_per_stable
  end
end
