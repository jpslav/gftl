class PreseasonRankingsController < ApplicationController

  before_filter :admin_required
 
  def move_ranking_up
    handle_ranking_action(params[:rankings],:moveRankingUp)
  end
  
  def move_ranking_down
    handle_ranking_action(params[:rankings],:moveRankingDown)
  end
 
  # GET /preseason_rankings
  # GET /preseason_rankings.xml
  def index
    @rankings = PreseasonRanking.find_all_by_year(Time.now.year, :order => "ranking")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preseason_rankings }
    end
  end

#  # GET /preseason_rankings/1
#  # GET /preseason_rankings/1.xml
#  def show
#    @preseason_ranking = PreseasonRanking.find(params[:id])#
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @preseason_ranking }
#    end
#  end

  # GET /preseason_rankings/new
  # GET /preseason_rankings/new.xml
  def new
    @preseason_ranking = PreseasonRanking.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @preseason_ranking }
    end
  end

  # GET /preseason_rankings/1/edit
#  def edit
#    @preseason_ranking = PreseasonRanking.find(params[:id])
#  end

#  # POST /preseason_rankings
#  # POST /preseason_rankings.xml
#  def create
#    @preseason_ranking = PreseasonRanking.new(params[:preseason_ranking])
#
#    respond_to do |format|
#      if @preseason_ranking.save
#        flash[:notice] = 'PreseasonRanking was successfully created.'
#        format.html { redirect_to(@preseason_ranking) }
#        format.xml  { render :xml => @preseason_ranking, :status => :created, :location => @preseason_ranking }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @preseason_ranking.errors, :status => :unprocessable_entity }
##      end
#    end
#  end

#  # PUT /preseason_rankings/1
#  # PUT /preseason_rankings/1.xml
#  def update
#    @preseason_ranking = PreseasonRanking.find(params[:id])#
#
#    respond_to do |format|
#      if @preseason_ranking.update_attributes(params[:preseason_ranking])
#        flash[:notice] = 'PreseasonRanking was successfully updated.'
#        format.html { redirect_to(@preseason_ranking) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @preseason_ranking.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /preseason_rankings/1
  # DELETE /preseason_rankings/1.xml
#  def destroy
#    @preseason_ranking = PreseasonRanking.find(params[:id])
#    @preseason_ranking.destroy#
#
#    respond_to do |format|
#      format.html { redirect_to(preseason_rankings_url) }
#      format.xml  { head :ok }
#    end
#  end

private
  
  def handle_ranking_action(ranking_id, action)
    return if ranking_id.nil?

    selectedRanking = PreseasonRanking.find(ranking_id)
      
    case action
    when :moveRankingUp: selectedRanking.moveEarlier
    when :moveRankingDown: selectedRanking.moveLater
    end
    
    # Generate the partial for the ranking list (for this, we need to ordered 
    # list of rankings and the index of the one that should be selected)
    
    @rankings = PreseasonRanking.find_all_by_year(Time.now.year, :order => "ranking")
    @selected_ranking_id = ranking_id.to_i
    render :partial => 'ranking_list'
  end


end
