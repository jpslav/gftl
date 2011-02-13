class OwnedStable < ActiveRecord::Base

  validates_uniqueness_of :league_membership_id
  validates_presence_of :franchise_car_id, :darkhorse_car_id, :league_membership_id
  # validate :cars_not_same
  # validate :cars_unique_to_league

  belongs_to :franchise_car, :class_name => "Car", :foreign_key => "franchise_car_id"
  belongs_to :darkhorse_car, :class_name => "Car", :foreign_key => "darkhorse_car_id"
  belongs_to :league_membership

  # For the time being we're not validating here, but instead just giving valid
  # options to the users.
  #
  # validate_on_update :valid_darkhorse?
  # 
  # protected
  # 
  # def valid_darkhorse?
  #   darkhorseCar.validDarkhorse?
  # end
  
  
  # def cars_not_same
  #   errors.add('Both cars cannot be the same') if :_id == :car2_id
  # end
  # 
  # def cars_unique_to_league
  #   other_stables = league_membership.league.league_memberships.reject{|m| m == league_membership}.collect{|m| m.owned_stable}.reject{|s| s.nil?}
  #   other_cars = other_stables.collect{|s| [s.car2, s.car1]}.flatten
  #   logger.debug other_stables.inspect
  #   logger.debug other_cars.inspect
  #   errors.add('One or both of the selected cars are already a part of another owner\'s stable in this league') if 
  #     other_cars.include?(car1) || other_cars.include?(car2)
  # end
end
