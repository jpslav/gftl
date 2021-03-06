class LeaguesController < ApplicationController

  before_filter :admin_required
  
  helper :table
  
  # GET /leagues
  # GET /leagues.xml
  def index
    @leagues = League.all
    @load_javascript = true

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @leagues }
    end
  end

  # GET /leagues/1
  # GET /leagues/1.xml
  def show
    @league = League.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @league }
    end
  end

  # GET /leagues/new
  # GET /leagues/new.xml
  def new
    @league = League.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @league }
    end
  end

  # GET /leagues/1/edit
  def edit
    @league = League.find(params[:id])
  end

  # POST /leagues
  # POST /leagues.xml
  def create
    @league = League.new(params[:league])

    respond_to do |format|
      if @league.save
        flash[:notice] = 'League was successfully created.'
        format.html { redirect_to(@league) }
        format.xml  { render :xml => @league, :status => :created, :location => @league }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def email_standings
    League.all.each{|l| l.email_standings}
    flash[:notice] = "Standings email sent"
    redirect_to leagues_path
  end
  
  def email_everyone
    League.all.each{|l| l.email(params[:broadcast_subject], params[:broadcast_message])}
    flash[:notice] = "Broadcast message sent"
    redirect_to leagues_path
  end
  


  # PUT /leagues/1
  # PUT /leagues/1.xml
  def update
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        flash[:notice] = 'League was successfully updated.'
        format.html { redirect_to(@league) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.xml
  def destroy
    @league = League.find(params[:id])
    
    errorMessage = ""
    
    if !@league.league_memberships.empty?
      errorMessage += "Cannot delete league '" + @league.name + "' because it has members.";
    else
      @league.destroy
    end
    


    respond_to do |format|
      if errorMessage.length != 0
        flash[:error] = errorMessage
      end
      
      format.html { redirect_to(leagues_url) }
      format.xml  { head :ok }
    end
  end
end
