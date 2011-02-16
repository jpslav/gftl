class PreseasonRankingsController < ApplicationController

  before_filter :admin_required
 
  # GET /preseason_rankings
  # GET /preseason_rankings.xml
  def index
    @rankings = PreseasonRanking.find_all_by_year(Time.now.year, :order => "position")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preseason_rankings }
    end
  end

  def sort
    sorted_ranking_ids = params['rank']
    
     PreseasonRanking.transaction do
        nextPosition = 0
        sorted_ranking_ids.each do |oid|
          ranking = PreseasonRanking.find(oid)
          ranking.position = nextPosition
          ranking.save!
          nextPosition = nextPosition + 1
        end
      end
    
    render :nothing => true
  end

 
end
