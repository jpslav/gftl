class AddFranchiseCarIdAndDarkhorseCarIdToOwnedStables < ActiveRecord::Migration
  def self.up
    add_column :owned_stables, :franchise_car_id, :integer
    add_column :owned_stables, :darkhorse_car_id, :integer
    
    remove_column :owned_stables, :car1_id
    remove_column :owned_stables, :car2_id
  end

  def self.down
    remove_column :owned_stables, :darkhorse_car_id
    remove_column :owned_stables, :franchise_car_id
    
    add_column :owned_stables, :car1_id, :integer
    add_column :owned_stables, :car2_id, :integer
  end
end
