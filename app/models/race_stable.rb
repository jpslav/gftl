class RaceStable < ActiveRecord::Base
  
   validates_uniqueness_of :league_membership_id, :scope => :race_id
   validates_presence_of :car1_id, :car2_id, :car3_id, :car4_id, :league_membership_id, :race_id
   # validate :cars_not_same
   # validate :cars_unique_in_league_and_race

   belongs_to :car1, :class_name => "Car", :foreign_key => "car1_id"
   belongs_to :car2, :class_name => "Car", :foreign_key => "car2_id"
   belongs_to :car3, :class_name => "Car", :foreign_key => "car3_id"
   belongs_to :car4, :class_name => "Car", :foreign_key => "car4_id"
   belongs_to :league_membership
   belongs_to :race

   protected
   # def cars_not_same
   #   cars = orderedCars.collect{|c| c.id}
   #   errors.add('At least one car is used more than once in this stable') if cars.uniq.length != 5
   # end
   # 
   # def cars_unique_in_league_and_race
   #   other_stables = league_membership.league.league_memberships.reject{|m| m == league_membership}.collect{|m| m.race_stables}.flatten.reject{|s| s.nil?}
   #   other_stables = other_stables.select{|s| s.race_id == race_id}
   #   other_cars = other_stables.collect{|s| [s.car1, s.car2, s.car3, s.car4, s.car5]}.flatten
   # 
   #   errors.add('One or more of the selected cars are already a part of another owner\'s race stable in this league') if 
   #     other_cars.include?(car1) || other_cars.include?(car2) || other_cars.include?(car3) || other_cars.include?(car4) || other_cars.include?(car5) 
   # end
   
   public
   def orderedCars
     [car1, car2, car3, car4]
   end
   
   def orderedCarIds
     [car1_id, car2_id, car3_id, car4_id]
   end
   
   def orderedCarNumbers
     orderedCars.collect{|c| c.number}
   end
   
   def points
     results = RaceResult.find_all_by_race_id(race_id).to_a
     #points = results.sum {|result| (orderedCarIds.include?(result.car_id) ? result.points_delta * orderedCarIds.count(result.car_id) : 0)}
     points = results.sum {|result| result.points_delta * orderedCarIds.count(result.car_id)}
   end
   
   def worst_car_points
     results = RaceResult.find_all_by_race_id(race_id).to_a
     points = results.collect{|result| result.points_delta * orderedCarIds.count(result.car_id)}   
     points.min  
   end
end
