class RaceStablesController < ApplicationController

  before_filter :admin_required
  
  # GET /race_stables
  # GET /race_stables.xml
  def index
    @race_stables = RaceStable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @race_stables }
    end
  end

  # GET /race_stables/1
  # GET /race_stables/1.xml
#  def show
#    @race_stable = RaceStable.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @race_stable }
#    end
#  end

  # GET /race_stables/new
  # GET /race_stables/new.xml
  def new
    @race_stable = RaceStable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @race_stable }
    end
  end

  # GET /race_stables/1/edit
  def edit
    @race_stable = RaceStable.find(params[:id])
  end

  # POST /race_stables
  # POST /race_stables.xml
  def create
    @race_stable = RaceStable.new(params[:race_stable])

    respond_to do |format|
      if @race_stable.save
        flash[:notice] = 'RaceStable was successfully created.'
        format.html { redirect_to race_stables_path }
        format.xml  { render :xml => @race_stable, :status => :created, :location => @race_stable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @race_stable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /race_stables/1
  # PUT /race_stables/1.xml
  def update
    @race_stable = RaceStable.find(params[:id])

    respond_to do |format|
      if @race_stable.update_attributes(params[:race_stable])
        flash[:notice] = 'RaceStable was successfully updated.'
        format.html { redirect_to race_stables_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @race_stable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /race_stables/1
  # DELETE /race_stables/1.xml
  def destroy
    @race_stable = RaceStable.find(params[:id])
    @race_stable.destroy

    respond_to do |format|
      format.html { redirect_to(race_stables_url) }
      format.xml  { head :ok }
    end
  end
  
  def run_weekly_draft
    League.all.select{|l| l.this_year?}.each do |l|
      stables = l.run_weekly_draft(Race.nextRace, params[:excluded_car_numbers].split(" "))
      stables.values.each{|s| s.save}
    end
    redirect_to race_stables_path
  end
  
  def email_weekly_draft_results
    League.all.each{|l| l.email_race_draft_results}
    flash[:notice] = "Email sent"
    redirect_to race_stables_path
  end
end
