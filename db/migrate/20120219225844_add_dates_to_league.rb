class AddDatesToLeague < ActiveRecord::Migration
  def self.up
    add_column :leagues, :allstar_race_date, :datetime
    add_column :leagues, :first_chase_race_date, :datetime
  end

  def self.down
    remove_column :leagues, :first_chase_race_date
    remove_column :leagues, :allstar_race_date
  end
end
