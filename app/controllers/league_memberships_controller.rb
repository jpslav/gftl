class LeagueMembershipsController < ApplicationController
  # GET /league_memberships
  # GET /league_memberships.xml
  
  def index
    @load_javascript = true
    
    current_user_memberships = 
      LeagueMembership.find_all_by_owner_id(current_user.owners.collect {|o| o.id}).to_a
    
    current_user_league_ids = current_user_memberships.collect {|lm| lm.league_id}.uniq
     
    @current_user_leagues = League.find(current_user_league_ids).to_a
    
    @available_draft_lists = current_user.draft_lists
    
    # Delete this soon
       @league_memberships = 
          LeagueMembership.find_by_owner_id(current_user.owners.collect {|o| o.id}).to_a
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => LeagueMembership.all }
    end
  end

  # GET /league_memberships/1
  # GET /league_memberships/1.xml
  def show
    @league_membership = LeagueMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @league_membership }
    end
  end

  # GET /league_memberships/new
  # GET /league_memberships/new.xml
  def new
    @league_membership = LeagueMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @league_membership }
    end
  end

  # GET /league_memberships/1/edit
  def edit
    @league_membership = LeagueMembership.find(params[:id])
  end

  # POST /league_memberships
  # POST /league_memberships.xml
  def create
    @league_membership = LeagueMembership.new(params[:league_membership])
    
    if @league_membership.league.num_members == 0 
      @league_membership.is_administrator = true
      
      logger.info("#{@league_membership.owner.name} is the first member of " +
                  "league #{@league_membership.league.name} and has therefore" +
                  " been made its administrator.")
    end
    
    respond_to do |format|
      if !(params[:password] == @league_membership.league.password)
        @league_membership.errors.add(:password, "The password is incorrect.")
      elsif @league_membership.save
        flash[:notice] = "You joined the league #{@league_membership.league.name}."
        format.html { redirect_to() }
        format.xml  { render :xml => @league_membership, :status => :created, :location => @league_membership }
      end
      
        format.html { render :action => "new" }
        format.xml  { render :xml => @league_membership.errors, :status => :unprocessable_entity }
      
    end
  end

  # PUT /league_memberships/1
  # PUT /league_memberships/1.xml
  def update
    @league_membership = LeagueMembership.find(params[:id])

    respond_to do |format|
      if @league_membership.update_attributes(params[:league_membership])
        flash[:notice] = 'LeagueMembership was successfully updated.'
        format.html { redirect_to(@league_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @league_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /league_memberships/1
  # DELETE /league_memberships/1.xml
  def destroy
    @league_membership = LeagueMembership.find(params[:id])
    @league_membership.destroy if (current_user.is_administrator)

    respond_to do |format|
      format.html { redirect_to(league_memberships_url) }
      format.xml  { head :ok }
    end
  end
  
  def play
    membership = LeagueMembership.find_by_id(params[:id])
    
    if !(membership.owner.user == current_user)
      flash[:error] = "You selected an invalid membership to play."
    else
      current_user.current_league_membership_id = params[:id]
      current_user.save
    end
    
    redirect_to(league_memberships_url)
  end
  
  def select_draft_list
    logger.info(params.inspect)
    
    membership = LeagueMembership.find_by_id(params[:membership_id])
    membership.active_draft_list_id = params[:chosen_draft_list]
    membership.save!

    redirect_to(league_memberships_url)    
  end
  
  def select_darkhorse
    logger.info(params.inspect)
    
    membership = LeagueMembership.find_by_id(params[:membership_id])
    membership.darkhorse_car_id = params[:chosen_darkhorse]
    membership.save!
    
    redirect_to(league_memberships_url)    
  end
end
