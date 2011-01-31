#require 'digest/sha1'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

#  validates_presence_of     :email
#  validates_presence_of     :password,                   :if => :password_required?
#  validates_presence_of     :password_confirmation,      :if => :password_required?
#  validates_length_of       :password, :within => 4..40, :if => :password_required?
#  validates_confirmation_of :password,                   :if => :password_required?
#  validates_length_of       :login,    :within => 3..40
#  validates_length_of       :email,    :within => 3..100
#  validates_uniqueness_of   :login, :case_sensitive => false
#  validates_uniqueness_of   :email, :case_sensitive => false#,
#                            :if => Proc.new { |u| !(u.email == "jpslav@yahoo.com") }

#  validates_presence_of     :first_name, :last_name

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.

  has_many :owners
  has_many :draft_lists

#  # Activates the user in the database.
#  def activate
#    @activated = true
#    self.activated_at = Time.now.utc
#    self.activation_code = nil
#    save(false)
#  end

#  def active?
#    # the existence of an activation code means they have not activated yet
#    activation_code.nil?
#  end

#  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
#  def self.authenticate(login, password)
#    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
#    u && u.authenticated?(password) ? u : nil
#  end

#  # Encrypts some data with the salt.
#  def self.encrypt(password, salt)
#    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
#  end

  # # Encrypts the password with the user salt
  # def encrypt(password)
  #   self.class.encrypt(password, salt)
  # end
  # 
  # def authenticated?(password)
  #   crypted_password == encrypt(password)
  # end
  # 
  # def remember_token?
  #   remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  # end
  # 
  # # These create and unset the fields required for remembering users between browser closes
  # def remember_me
  #   remember_me_for 2.weeks
  # end
  # 
  # def remember_me_for(time)
  #   remember_me_until time.from_now.utc
  # end
  # 
  # def remember_me_until(time)
  #   self.remember_token_expires_at = time
  #   self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
  #   save(false)
  # end
  # 
  # def forget_me
  #   self.remember_token_expires_at = nil
  #   self.remember_token            = nil
  #   save(false)
  # end

  # # Returns true if the user has just been activated.
  # def recently_activated?
  #   @activated
  # end

  def current_league_membership
    return nil if -1 == current_league_membership_id
    
    return LeagueMembership.find_by_id(current_league_membership_id)
  end

  def full_name
    return first_name + " " + last_name
  end
  
#  def change_password(password)
#    crypted_password = encrypt(password)
#    save!
#  end

  # protected
  #    # before filter 
  #    def encrypt_password
  #      return if password.blank?
  #      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
  #      self.crypted_password = encrypt(password)
  #    end
  #      
  #    def password_required?
  #      crypted_password.blank? || !password.blank?
  #    end
  #    
  #    def make_activation_code
  # 
  #      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  #    end
    
end
