class LeagueMembership < ActiveRecord::Base
  
  validates_presence_of :league_id, :owner_id, :active_draft_list_id, :franchise_car_id, :darkhorse_car_id

  
  validates_uniqueness_of :owner_id, 
                          :scope => :league_id, 
                          :message => "The specified owner is already a member of the specified league."
  
  belongs_to :league
  belongs_to :owner
  belongs_to :draft_list, :class_name => "DraftList", :foreign_key => "active_draft_list_id"
  has_many :race_stables

  belongs_to :franchise_car, :class_name => "Car", :foreign_key => "franchise_car_id"
  belongs_to :darkhorse_car, :class_name => "Car", :foreign_key => "darkhorse_car_id"
  
  # TODO clean up how we do times!!
  
  # @@day_before_allstar_race = Time.local(Time.now.year,5,20)
  # @@day_before_start_of_chase = Time.local(Time.now.year,9,17)
  # 
  # @@first_half_bounds = [Time.local(Time.now.year,1,1), @@day_before_allstar_race]
  # @@second_half_bounds = [@@day_before_allstar_race, @@day_before_start_of_chase]
  # @@chase_bounds = [@@day_before_start_of_chase, Time.local(Time.now.year,12,31)]
  
  
  def first_half_bounds
    [Time.local(league.year,1,1), -1.days.since(league.allstar_race_date)]
  end
  
  def second_half_bounds
    [-1.days.since(league.allstar_race_date), -1.days.since(league.first_chase_race_date)]
  end
  
  def chase_bounds
    [-1.days.since(league.first_chase_race_date), Time.local(league.year,12,31)]
  end
  
  def toString
    return owner.name + "/" + league.name
  end
  
  def current_mini_chase_points
    now = Time.now
    
    first_half_end = Race.raceJustAfter(first_half_bounds[1]).racetime
    second_half_end = Race.raceJustAfter(second_half_bounds[1]).racetime
    
    if now >= first_half_bounds[0] && now < first_half_end
      return firstHalfPoints
    elsif now >= first_half_end && now < second_half_end
      return secondHalfPoints
    else
      return chasePoints
    end 
  end
  
  def firstHalfPoints
    mini_chase_points(first_half_bounds[0], first_half_bounds[1])
  end
  
  def secondHalfPoints
    mini_chase_points(second_half_bounds[0], second_half_bounds[1])
  end
  
  def chasePoints
    mini_chase_points(chase_bounds[0], chase_bounds[1])
  end
  
  def mini_chase_points(start_datetime, end_datetime)
    points = 0
    
    stables = race_stables.select{|s| s.race.racetime >= start_datetime && s.race.racetime <= end_datetime}
    
    stables.each do |s|
      points += s.points
    end
    
    points
  end
  
  def last_stable
    RaceStable.find_by_league_membership_id_and_race_id(id, Race.lastRace.id)
  end
  
  def personal_best_week_points
    race_stables.collect{|s| s.points}.max
  end
  
  def personal_worst_week_points
    points = race_stables.collect{|s| s.points}
    points.reject! {|p| p == 0 }
    points.min
  end

end
