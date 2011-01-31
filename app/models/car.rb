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
    cars = Car.find_all_by_year(Time.now.year).sort{|a,b| b.total_points <=> a.total_points}
    cars[0..34]
  end
end
