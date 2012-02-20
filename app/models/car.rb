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
  
  def self.darkhorseCandidates(year,league=nil)
    year = league.year if !league.nil?
    candidates = Car.find_all_by_year(year)
    candidates.sort{|a,b| a.number.to_i <=> b.number.to_i}
  
    preseasonTop12Cars = PreseasonRanking.top12(year).collect{|c| c.number}
    franchiseCars = league.nil? ? [] : league.franchiseCars.collect{|c| c.number}
    top10Cars = !RaceResult.anyForYear(year) ? [] : Car.top_10.collect{|c| c.number}
    
    candidates.delete_if do |c|
      preseasonTop12Cars.include?(c.number) ||
      franchiseCars.include?(c.number) ||
      top10Cars.include?(c.number)
    end
    
    # candidates.delete_if {|c| !c.validDarkhorse?(league)}
  end
  
  def validDarkhorse?(league=nil)
    !PreseasonRanking.top12(self.year).collect{|c| c.number}.include?(self.number) &&
    
    (league.nil? || 
     !league.franchiseCars.collect{|c| c.number}.include?(self.number)) &&
     
    (!RaceResult.anyForYear(self.year) || 
     !Car.top_10.collect{|c| c.number}.include?(self.number))
  end
end
