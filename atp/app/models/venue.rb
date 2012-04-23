class Venue < ActiveRecord::Base
  include CityByZip
  belongs_to :user
  belongs_to :city
  has_many :parties, :through => :events
  has_many :events, :order => "happens_at asc"
  has_many :image_sets, :through => :events
  has_many :missed_connections
  has_many :faves, :as => :obj, :dependent => :destroy
  acts_as_taggable
  acts_as_rateable
  acts_as_commentable
  acts_as_voteable
  validates_presence_of       :user_id, :name, :address, :city_name, :state, :country
  validates_associated        :user
  validates_length_of         :name, :within => 1..45
  validates_length_of         :address, :within => 3..75
  validates_length_of         :city_name, :within => 2..45
  validates_length_of         :state, :within => 2..45
  
  def self.blank(options={})
    new({
      :active => true,
      :country => "us"
    }.merge(options))
  end
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  def self.update_all_city_ids
    CITY_ZIPS.each do |key,val|
      city = City.find(:first, :conditions => ["short_name = ?", key.to_s])
      update_all("city_id=#{city.id}", "postal_code in (#{val[:zips].join(',')})") unless city.nil?
    end
  end
  
  def full_address
    "#{self.address}, #{self.city_name}, #{self.state}, #{self.postal_code}"
  end
  
  def pictures(offset=0, limit=5)
    self.events.find(:all, :conditions => 'events.image_sets_count > 0', :order => "events.happens_at desc", :offset => offset, :limit => limit)
  end
  
  def active_events(offset=0, limit=5)
    self.events.find(:all, :conditions => ["events.active = 1 AND events.happens_at > ?", Time.now.utc], :order => "events.happens_at asc", :offset => offset, :limit => limit)
  end
  
  def to_param
    "#{id}-#{[name, address, city_name, state].join(' ').gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  protected
  def before_save
    if self.country == "us"
      postal_code_info = PostalCode.find_zipinfo(self.postal_code)
      self.city_name =  postal_code_info.CityName
      self.state = postal_code_info.StateAbbr
      self.time_zone = postal_code_info.tz
    end
    self.city_id = City.find_by_short_name(get_city_name(self.postal_code).to_s).id rescue 0
  end
  
  def after_create
    Audit.log(self, self.user.username, 'new', "New Venue: #{self.name} (#{self.city}, #{self.state})")
  end
end