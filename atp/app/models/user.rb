require 'digest/md5'
include StringFunction
include Countries
class User < ActiveRecord::Base
  has_many :guestlists
  #has_one :service
  has_many :ads
  has_and_belongs_to_many :roles
  has_many :faves, :as => :obj, :dependent => :destroy
  has_many :missed_connections
  has_many :msgs, :foreign_key => :receiver_id, :conditions => "deleted_by_receiver = 0"
  has_many :confessions
  has_many :orders
  has_many :image_sets, :as => :obj, :dependent => :destroy, :order => "position"
  has_many :images
  has_many :comments
  
  #for profile
  has_many :interests
  has_many :turn_offs
  has_many :turn_ons
  has_many :relationship_types
  #friends
  has_many :friends, :foreign_key => :fp, :conditions => "a=1"
  has_many :friends_in_waiting, :class_name=> :friends, :foreign_key => :fp, :conditions => "a=0"
  has_many :banned_people, :class_name => :friends, :foreign_key => :fp, :conditions => "a=-1"
  
  #for users with promoter roles
  has_many :parties
  has_many :billing_profiles
  has_many :events, :through => :parties
  has_many :taggings
  has_many :tags, :through => :taggings, :select => "DISTINCT tags.*" #, :uniq => true

  validates_presence_of       :password,                   :if => :password_required?
  validates_presence_of       :password_confirmation,      :if => :password_required?
  validates_length_of         :password, :within => 5..40, :if => :password_required?
  validates_confirmation_of   :password,                   :if => :password_required?
  validates_confirmation_of   :email,                      :if => :password_required?
  validates_length_of         :email, :within => 7..60
  validates_format_of         :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "is invalid."
  validates_length_of         :username, :within => 3..75
  validates_format_of         :username, :with => /^[a-zA-Z0-9][\-a-zA-Z0-9\_\.]+$/, :message => "must contain only a-z A-Z 0-9 _ . or - and start with A-Z a-z 0-9"
  validates_inclusion_of      :sex, :in=>%w( m f ), :message=>"woah! what are you then!??!!"
  validates_uniqueness_of     :email, :username
  validates_presence_of       :username, :email, :sex, :country, :site_id
  
  before_save :encrypt_password
  attr_accessor :password, :city, :state
  
  class << self
    def blank(options={})
      new({
        :password_hash => nil,
        :password_salt => nil,
        :deleted => false,
        :classic_view => true,
        :email_messages_allowed => true,
        :allow_admin_mails => true,
        :time_zone => "Eastern Time (US & Canada)",
        :country => "us"
      }.merge(options))
    end
    
    def authenticate_using_params(params)
      authenticate(params[:user][:username], params[:user][:password], params[:md5].to_i == 1)
    end
    
    # Authenticates a user by their username name and unencrypted password.  Returns the user or nil.
    def authenticate(username, password, md5 = false)
      # use this instead if you want user activation
      username = makesafe( username.gsub(/&#([0-9+])/, '-') )
      username = stripslashes(username)
      username = username.downcase.gsub(/&#124;/, '|')
      password = makesafe(password.gsub(/&#([0-9+])/, '-'))
      password = stripslashes(password)
      u = find :first, :conditions => ["username = ?", username] # need to get the salt
      return :false unless u
      return :false if u.deleted == true
      password_salt = u.password_salt.sub(/\\\\/, '\\')
      password = Digest::MD5.hexdigest(password) if md5 == false
      return u if u.generate_hash(password_salt, password) == u.password_hash
      return :false
    end

    def get_mailing_list_since(date=1.week.ago, offset=0, limit=5000)
      range = (date..Time.now.utc).to_s(:db)
      sx = User.sex.invert
      promoter = Role.find_by_name('Promoter')
      u=find(:all,
        :select => "username, email, postal_code, mobile, mobile_carrier, sex, roles.*", 
        :conditions => "users.created_on #{range} AND email_messages_allowed=1 AND allow_admin_mails=1 AND deleted=0",
        :include => [:roles],
        :offset => offset,
        :limit => limit)
      u.collect{|l| "#{l.username}, #{l.email}, #{sx[l.sex].downcase}, #{l.postal_code}, #{l.roles.include?(promoter) ? 1 : 0}, T, #{l.mobile||0}, #{l.mobile_carrier||0}" }
    end

    def find_like_by_email_or_username(term)
      find(:all, :conditions => "email like '%#{term}%' OR username like '%#{term}%'", :limit => 50)
    end

    def sex
      { 'Female' => 'f', 'Male' => 'm' }
    end
  
    def mobile_carriers
      ["AT&T", "Air Mail", "Alltel", "Arch Wireless", "Boost Mobile", "Cingular", "Cricket Wireless", "Earthlink", "Helio", "MCI Paging", "My 2-Way", "Nextel", "Page-Net", "Skytel", "Sprint PCS", "T-Mobile", "Verizon", "Virgin Mobile", "Voicestream", "Worldcom"]
    end

    def countries
      Countries.all.sort
    end
  end

  def generate_hash(salt, md5_once_password)
    salt = Digest::MD5.hexdigest("#{salt}")
    Digest::MD5.hexdigest("#{salt}#{md5_once_password}")
  end
  
  def testimonials
    Comment.find_comments_for_commentable("User", self.id )
  end

  def role_names
    self.roles.map(&:name)
  end
  
  protected
  # before filter 
  def encrypt_password
    return if password.blank?
    if new_record?
      self.member_login_key = Digest::MD5.hexdigest("#{generate_challenge(60)}")
      self.password_salt = generate_challenge(5)
    end
    self.password_hash = generate_hash(self.password_salt, Digest::MD5.hexdigest("#{password}"))
  end

  def password_required?
    password_hash.blank? or not password.blank?
  end
  
  def validate
    if self.country == "us"
      zipinfo = PostalCode.find_zipinfo(self.postal_code)
      if zipinfo.class == PostalCode
        self.location = zipinfo.CityName + ", " + zipinfo.StateAbbr
        self.time_zone = zipinfo.tz
      else
        errors.add("postal_code", "is not valid.")
      end
    end
  end
  
  def validate_on_update
    ## validate unique username
    if User.find(:first, { :conditions => ["username=? and id <> ?", self.username, self.id]})
      errors.add("username", "is not available.")
    end
    ## validate unique email
    if User.find(:first, { :conditions => ["email=? and id <> ?", self.email, self.id]})
      errors.add("email", "is not available.")
    end
  end
  
  def before_save
    if self.country == "us"
      postal_code_info = PostalCode.find_zipinfo(self.postal_code)
      self.location = postal_code_info.CityName + ", " + postal_code_info.StateAbbr
      self.time_zone = postal_code_info.tz
    end
  end
  
  #validates_presence_of       :company_name
end