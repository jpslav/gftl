class LeagueStats

  attr_reader :mini_chase_points
  attr_reader :ranked_members
  attr_reader :last_week_points
  attr_reader :previous_standings
  attr_reader :standings
  attr_reader :standings_change
  attr_reader :park_and_stop_awards
  attr_reader :id_with_highest_personal_best
  attr_reader :id_with_lowest_personal_best
  attr_reader :num_races
  attr_reader :personal_worsts
  attr_reader :personal_bests
  attr_reader :members

  def initialize(league)
    @members = league.league_memberships
    member_ids = @members.collect{|m| m.id}
    
    # Put in logic for before first race of each chase, etc
    
    @mini_chase_points = @members.make_hash{|m| [m.id, m.current_mini_chase_points]}
    @ranked_members = @members.sort{|a,b| b.current_mini_chase_points <=> a.current_mini_chase_points}
    @last_week_points = @members.make_hash{|m| [m.id, m.last_stable.nil? ? 0 : m.last_stable.points]}
    
    previous_mini_chase_points = {}
    @mini_chase_points.each_pair{|id, points| previous_mini_chase_points[id] = points-@last_week_points[id]}
   
    previous_ordered_member_ids = previous_mini_chase_points.sort{|a,b| b[1]<=>a[1]}.collect{|x| x[0]}
    
    @previous_standings = {}
    standing = 0
    previous_ordered_member_ids.each do |id|
      @previous_standings[id] = standing += 1
    end
    
    @standings = {}
    standing = 0
    @ranked_members.each do |rm|
      @standings[rm.id] = standing += 1
    end
    
    @standings_change = {}
    @standings.each_pair{|id, standing| @standings_change[id] = -standing + @previous_standings[id]}
    
    return if !Race.firstRaceOfYear(league.year).race_results.any?
    
    @personal_bests = {}
    @personal_worsts = {}
    @members.each do |member|
      @personal_bests[member.id] = member.personal_best_week_points
      @personal_worsts[member.id] = member.personal_worst_week_points
    end
    
    @id_with_highest_personal_best = @personal_bests.max_by{|a| a[1]}[0]
    @id_with_lowest_personal_best = @personal_worsts.min_by{|a| a[1]}[0]
    
    @park_and_stop_awards = {}
    member_ids.each{|id| @park_and_stop_awards[id] = 0}

    races = Race.racesUpToToday

    @num_races = races.length

    races.each do |race|
      stables = RaceStable.all(:conditions => ["league_membership_id IN (?) AND race_id = ?", 
                                              member_ids, race.id])
      stable_points = stables.make_hash{|s| [s.points, s.league_membership.id]}
      sorted_stable_points = stable_points.sort
      
      loser_ids = (sorted_stable_points.select{|s| s[0] == sorted_stable_points[0][0]}).collect{|s| s[1]}
      
      if loser_ids.length == 1
        loser_id = loser_ids[0]
      else
        loser_stables = stables.select{|s| loser_ids.include?(s.league_membership.id)}
        reduced = loser_stables.make_hash{|ls| [ls.worst_car_points, ls.league_membership.id]}
        loser_id = reduced.sort[0][1]
      end

      @park_and_stop_awards[loser_id] += 1
    end
    
    
  end
  
end