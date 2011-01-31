class League < ActiveRecord::Base
  validates_presence_of :name, :year, :max_owners, :password
  validates_uniqueness_of :name, :scope => [:year]
  validates_format_of :year, :with => /^\d\d\d\d$/
  validates_length_of       :password,    :within => 1..40
  
  has_many :league_memberships
  
  protected
  def validate
    errors.add(:year, "The year should be after 2009.") if year < 2010
    
    if max_owners < 2 || max_owners > 10
      errors.add(:max_owners, 
                 "The maximum number of owners should be in the range 2 to 10.")
    end
  end
  
  public 
  def self.find_open
    
    open_leagues = []
    
    self.find(:all).each do |league| 
      if league.is_allowing_registration?
        open_leagues.push(league)
      end
    end
    
    open_leagues
  end
  
  public
  def is_allowing_registration?
    is_registration_open && self.num_members < max_owners
  end
  
  public 
  def num_members
    LeagueMembership.count :conditions => {:league_id => id}
  end
  
  def email_standings
    LeagueMailer.standings(self).deliver if num_members > 0
  end
  
  def email_race_draft_results
    LeagueMailer.race_draft_results(self).deliver if num_members > 0
  end
  
  def last_race_winner

  end
  
  
  def run_initial_draft
    if is_registration_open
      raise "Cannot run the initial draft for a league whose registration is still open"
    end
    
    
  end
  
  # @param draft_race   the race for which we're running the draft
  #                     typically has value Race.nextRace
  # @return a hash of RaceStable, with the key being the member ID
  #
  def run_weekly_draft(draft_race)

    logger.info("Starting weekly draft for " + draft_race.name)
    
    # Determine the pool of cars who have automatically qualfied for the next race
    # (this is the top 35 in points from after the previous race)
    
    qualifiers = Car.top_35
    
    logger.debug("Initial race qualifiers: " + qualifiers.collect{|q| q.number}.join(", "))
    
    # Initialize a new race stable for each member.  Put each members's fixed 
    # cars into their stables, and remove those cars from the available pool.
    
    stables = {}
    
    league_memberships.each do |m|
      stables[m.id] = RaceStable.new(:league_membership_id => m.id, 
                                     :race_id => draft_race.id,
                                     :car1_id => m.owned_stable.car1_id,
                                     :car2_id => m.owned_stable.car2_id)
    
      qualifiers.reject!{|q| q.id == m.owned_stable.car1_id || 
                             q.id == m.owned_stable.car2_id}
    end
    
    logger.debug("After assigning fixed stables...")
    logger.debug("Stables:")
    logger.debug(stables.values.collect{|s| "  " + s.league_membership.owner.user.first_name + ": " + s.car1.number + ", " + s.car2.number}.join("\n"))
    #logger.debug(stables.values.collect{|s| "  " + s.league_membership.owner.user.first_name + ": " + s.car1.number}.join("\n"))
    logger.debug("Num qualifiers = " + qualifiers.count.to_s)
    logger.debug("Qualifiers: " + qualifiers.collect{|q| q.number}.join(", "))
    
    # Iterate through the four rounds of drafts.  In each round, iterate
    # through the owners in the following order:
    #
    #   Round 1:   lowest pts owner ... highest pts owner (if used)
    #   Round 2:   Random order
    #   Round 2:   lowest pts onwer ... highest pts owner
    #   Round 3:   highest pts owner ... lowest pts owner
    #
    # For each owner, iterate through their draft list looking for the
    # earliest entry (highest preference) in the list that is still in
    # the available pool.  Assign that driver to the (round+2) slot in
    # that owner's stable.
    
    # Get the league members sorted by points.  We need to use the
    # appropriate points for this point in the season  
    
    members_worst_to_best = 
      league_memberships.sort{|a,b| a.current_mini_chase_points <=> b.current_mini_chase_points}

    draft_order_by_round = [#members_worst_to_best, 
                            league_memberships.sort_by{rand},
                            members_worst_to_best, 
                            members_worst_to_best.reverse]

    draft_lists = {}
    league_memberships.each{|m| draft_lists[m.id]=m.draft_list.ranked_cars}
    
    car_index = 3
    draft_order_by_round.each do |members|
      members.each do |member|
        
        draft_lists[member.id].each do |car|
          
          if qualifiers.include?(car)
            stables[member.id].method("car" + car_index.to_s + "_id=").call(car.id)
            qualifiers.reject!{|q| q.id == car.id}
            logger.debug(member.owner.name + " drafts car " + car.number + " in slot " + car_index.to_s)
            break 
          end
          
        end
      end
      car_index = car_index + 1
    end
    
    stables
    
  end
  
  def raceStables
    league_memberships.collect{|m| m.race_stables}.flatten
  end
  
end
