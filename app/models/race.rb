

class Race < ActiveRecord::Base
  belongs_to :track
  has_many :race_results
  


  def self.racesUpToToday
    races = Race.find(:all, :conditions => ["racetime < ? and racetime > ?", Time.now.end_of_day, Time.now.beginning_of_year ]).to_a
  end
  
  def self.racesUpThroughNextOne
    races = racesUpToToday
    
    if races.empty?
      firstRace = Race.first(:conditions => ["racetime > ?", Time.now.beginning_of_year],:order => "racetime")
      
      return firstRace.nil? ? [] : [firstRace]
    end
    
    races.sort!{|x,y| x.racetime <=> y.racetime}
    nextRace = races.last.nextRace
    if !nextRace.nil?
      races.push(nextRace)
    end
    
    races
  end
  
  def nextRace
    Race.find(:all, :conditions => ["racetime > ?", self.racetime], :order => "racetime").first
  end
  
  def self.nextRace
    Race.racesUpThroughNextOne.last
  end
  
  def self.raceJustBefore(racetime)
    Race.find(:all, :conditions => ["racetime < ?", racetime], :order => "racetime").last
  end
  
  def self.raceJustAfter(time)
    Race.find(:all, :conditions => ["racetime > ?", time], :order => "racetime").first
  end
  
  def self.lastRace
    self.raceJustBefore(Time.now)
  end
  
  def standardRaceTimeString
    racetime.strftime('%b %d %Y, %I:%M %p')
  end
  
  def self.find_all_by_year (year) 
     Race.find(:all, :conditions => ["racetime < ? and racetime > ?", Time.local(year).end_of_year, Time.local(year).beginning_of_year])
  end
  
  def name_with_date
    name + " (" + racetime.strftime('%b %d %Y') + ")"
  end
  
  def self.firstRaceOfYear(year)
    find_all_by_year(year).sort {|x,y| x.racetime <=> y.racetime }.first
  end
  
  def self.firstRaceNotYetRun(year)
    Time.now < firstRaceOfYear(year).racetime
  end
  
end
