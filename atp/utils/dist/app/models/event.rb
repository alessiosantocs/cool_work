class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :party
  belongs_to :photographer, :class_name => "User", :foreign_key => "photographer_id"
  has_one :flyer, :as => :obj, :dependent => :destroy
  has_many :guestlists, :dependent => :destroy, :order => "full_name asc"
  has_many :image_sets, :as => :obj, :dependent => :destroy, :order => "position"
  
  validates_presence_of       :party_id, :venue_id, :happens_at, :search_date
  validates_length_of         :hosted_by,   :within => 3..50, :allow_nil => true
  validates_length_of         :synopsis,   :within => 3..1000, :allow_nil => true
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  def self.find_by_city_and_site(city_id, site_id)
    find(:all, :conditions => ["parties.city_id=? AND parties_sites.site_id=?", city_id, site_id], :include => [:party])
  end
  
  def self.images?
    self.image_sets_count > 0 ? true : false
  end
  
  def update_image_set_count
    self.update_attribute(:image_sets_count, image_sets.length)
  end
  
  def local_time(type=nil, offset=0)
    tz = TzinfoTimezone.new( self.venue.time_zone )
    lt = tz.utc_to_local( parse_time( self.happens_at+offset ) )
    case type
      when '12hr'
        lt.strftime("%I:%M%p")
      when '24hr'
        lt.strftime("%H:%M")
      when 'date'
        lt.strftime("%Y-%m-%d")
      else
      lt
    end
  end
  
  def set_uploaded(user_id)
    self.update_attributes({ :picture_uploaded => true, :picture_upload_time => Time.now , :photographer_id => user_id })
    party.decrement!(:pics_left)
  end
end