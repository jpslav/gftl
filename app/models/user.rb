#require 'digest/sha1'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_token, :first_name, :last_name

  validates_presence_of     :first_name, :last_name

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.

  has_many :owners, :dependent => :destroy
  has_many :draft_lists, :dependent => :destroy

  def current_league_membership
    return nil if -1 == current_league_membership_id
    
    return LeagueMembership.find_by_id(current_league_membership_id)
  end

  def full_name
    return first_name + " " + last_name
  end

end
