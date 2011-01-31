class RacePairingsController < ApplicationController
  # GET /race_pairings
  # GET /race_pairings.xml
  def index
    @race_pairings = RacePairing.find_all_by_league_membership(current_user.current_league_membership)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @race_pairings }
    end
  end

  # GET /race_pairings/1
  # GET /race_pairings/1.xml
  def show
    @race_pairing = RacePairing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @race_pairing }
    end
  end

  # POST /race_pairings
  # POST /race_pairings.xml
#  def create
#    @race_pairing = RacePairing.new(params[:race_pairing])
#
#    respond_to do |format|
#      if @race_pairing.save
#        flash[:notice] = 'RacePairing was successfully created.'
#        format.html { redirect_to(@race_pairing) }
#        format.xml  { render :xml => @race_pairing, :status => :created, :location => @race_pairing }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @race_pairing.errors, :status => :unprocessable_entity }
#      end
#    end
#  end


end
