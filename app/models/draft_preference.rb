class DraftPreference < ActiveRecord::Base
  
  belongs_to :draft_list
  belongs_to :car
  
public 

  def toString
    car.numberAndDriver
  end

    def moveEarlier  #TODO this method name kind of sucks!
      priorPreference = DraftPreference.find_by_draft_list_id_and_rank(self.draft_list.id, self.rank-1)
      DraftPreference.swapRanks(self, priorPreference)
    end  

    def moveLater
      nextPreference = DraftPreference.find_by_draft_list_id_and_rank(self.draft_list.id, self.rank+1)
      DraftPreference.swapRanks(self, nextPreference)
    end
    
private

  def self.swapRanks(preference1, preference2)
    if (!preference1.nil? && !preference2.nil?)

      # this doesn't work because these aren't really atomic assignments
      #preference1.sort_index = preference2.sort_index, preference2.sort_index = preference1.sort_index

      temp = preference1.rank
      preference1.rank = preference2.rank
      preference2.rank = temp

      preference1.save!
      preference2.save! # TODO any concern about momentarily having them both have the same sort_index? (in b/w saves)
                 # TODO put these two saves into a transaction!
    end
  end
  
end
