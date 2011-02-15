class DraftPreference < ActiveRecord::Base
  
  belongs_to :draft_list
  belongs_to :car
  
  acts_as_list
  
public 

  def toString
    car.numberAndDriver
  end
  
end
