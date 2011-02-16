class Car < ActiveRecord::Base
  
  validates_uniqueness_of :number, :scope => :year
  
  has_many :draft_preferences
  has_one :preseason_ranking
  
  def numberAndDriver
    number + " (" + normal_drivers + ")"
  end
  
  def self.populate_references
    Car.all.each do |c|
      c.populate_references
    end
  end
  
  def populate_references
    # Add this car to all draft lists 
    DraftList.add_car(self)
    
    # Add this car to the preseason rankings
    PreseasonRanking.add_car(self)
  end
  
  def total_points
    RaceResult.find_all_by_car_id(id).sum{|r| r.points_delta}
  end
  
  def self.top_35
    self.top(35)
  end
  
  def self.top_10
    self.top(10)
  end
  
  def self.top(numCars)
    cars = Car.find_all_by_year(Time.now.year).sort{|a,b| b.total_points <=> a.total_points}
    cars[0..numCars-1]
  end
  
  def self.darkhorseCandidates(year)
    candidates = Car.find_all_by_year(Time.now.year)
    candidates.sort{|a,b| a.number.to_i <=> b.number.to_i}
    candidates.delete_if {|c| !c.validDarkhorse?}
  end
  
  def validDarkhorse?
    !PreseasonRanking.top12(self.year).collect{|c| c.number}.include?(self.number) &&
    (!RaceResult.anyForYear(self.year) || 
     !Car.top_10.collect{|c| c.number}.include?(self.number))
  end
end
