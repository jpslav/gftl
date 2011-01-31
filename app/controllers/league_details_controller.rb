class LeagueDetailsController < ApplicationController
  def index
    @active_membership = current_user.current_league_membership
    
    if @active_membership.nil?
      flash[:error] = "To view league details you must have set your active league.  Click 'Play!' next to one of your memberships below to set your active league."
      redirect_to league_memberships_path
    else
      @show_data_for_all_members = session[:show_data_for_all_members] || false
    
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @active_membership }
      end
    end
  end

end
