class LeagueMailer < ActionMailer::Base
  default :from => "no-reply@gftl.jpslav.com"

  def standings(league)
    @league = league
    
    mail(:to => getRecipients(league),
         :subject => "[GFTL] " + " (SPOILER!) " + league.name + " Post-Race Report (" + Race.lastRace.name + ")")
  end

  def race_draft_results(league)
    @league = league
    
    mail(:to => getRecipients(league),
         :subject => '[GFTL] Draft Results for ' + Race.nextRace.name)
  end
  
  def broadcast_message(league, subject, message)
    @message = message
    
    mail(:to => getRecipients(league),
         :subject => '[GFTL] ' + subject)
  end
  
  def message(league_membership_sender, league_membership_receiver, subject, body)
    @body = body
    mail(:to => league_membership_receiver.owner.user.email,
         :from => league_membership_sender.owner.user.email,
         :subject => '[GFTL] ' + subject)
  end
  
  def getRecipients(league)
    league.league_memberships.collect{|m| m.owner.user.email}.join(", ")
  end

end