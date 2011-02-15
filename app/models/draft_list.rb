class DraftList < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  
  belongs_to :user
  has_many :league_memberships, :foreign_key => 'active_draft_list_id'
  has_many :draft_preferences
  
  def self.add_car(car)
    return if self.has_car(car)
    DraftList.find_all_by_year(car.year).each do |list|
      list.add_car(car)
    end
  end
  
  
  def add_car(car)
    next_rank = DraftPreference.count :conditions => {:draft_list_id => id}
    preference = DraftPreference.new(:draft_list_id => id, :car => car, :position => next_rank)
    preference.save!
  end
  
  public
  def self.has_car(car)
    DraftPreference.count(:conditions => {:car_id => car.id}) > 0
  end
  
  def destroy_preferences
    DraftPreference.find_all_by_draft_list_id(id).each do |preference|
      preference.destroy
    end
  end
  
  def ranked_car_numbers
    ranked_cars.collect {|c| c.number}.join(", ")
  end
  
  def ranked_cars
    DraftPreference.find_all_by_draft_list_id(id, :order => "position").collect{|dp| dp.car}
  end
  
  def ranked_preferences
    DraftPreference.find_all_by_draft_list_id(id, :order => "position")
  end
  
  def reorder_preferences(ordered_ids)
    DraftPreference.transaction do
      nextRank = 0
      ordered_ids.each do |oid|
        preference = DraftPreference.find(oid)
        preference.position = nextRank
        preference.save!
        nextRank = nextRank + 1
      end
    end
  end
  
end
