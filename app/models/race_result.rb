class RaceResult < ActiveRecord::Base
  
  validates_presence_of :car_id, :race_id, :points_delta
  validates_numericality_of :points_delta
  validates_uniqueness_of :car_id, 
                          :scope => :race_id, 
                          :message => "Results have already been entered for this car/race pair."
  
  belongs_to :race
  belongs_to :car
end
