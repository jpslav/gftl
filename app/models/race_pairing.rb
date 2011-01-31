class RacePairing < ActiveRecord::Base
  belongs_to :car
  belongs_to :league_membership
  belongs_to :race
end
