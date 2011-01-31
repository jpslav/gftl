class Owner < ActiveRecord::Base
  validates_presence_of :user_id, :name
  validates_uniqueness_of :name
  
  belongs_to :user
  has_many :league_memberships
end
