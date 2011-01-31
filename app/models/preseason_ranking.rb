class PreseasonRanking < ActiveRecord::Base
  belongs_to :car
  
  public 

  def self.add_car(car)
    return if self.has_car(car)
    next_ranking = PreseasonRanking.count :conditions => {:year => car.year}
    ranking = PreseasonRanking.new(:year => car.year, :ranking => next_ranking, :car => car)
    ranking.save!
  end
  
  
  def self.has_car(car)
    PreseasonRanking.count(:conditions => {:car_id => car.id}) > 0
  end

    def toString
      car.numberAndDriver
    end

      def moveEarlier  #TODO this method name kind of sucks!
        priorRanking = PreseasonRanking.find_by_year_and_ranking(self.year, self.ranking-1)
        PreseasonRanking.swapRanks(self, priorRanking)
      end  

      def moveLater
        nextRanking = PreseasonRanking.find_by_year_and_ranking(self.year, self.ranking+1)
        PreseasonRanking.swapRanks(self, nextRanking)
      end

  private

    def self.swapRanks(ranking1, ranking2)
      if (!ranking1.nil? && !ranking2.nil?)

        # this doesn't work because these aren't really atomic assignments
        #ranking1.sort_index = ranking2.sort_index, ranking2.sort_index = ranking1.sort_index

        temp = ranking1.ranking
        ranking1.ranking = ranking2.ranking
        ranking2.ranking = temp

        ranking1.save!
        ranking2.save! # TODO any concern about momentarily having them both have the same sort_index? (in b/w saves)
                   # TODO put these two saves into a transaction!
      end
    end
end
