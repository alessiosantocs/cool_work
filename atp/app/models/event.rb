class Event < ActiveRecord::Base
  named_scope :old, lambda { { :conditions => ['happens_at < ?', Time.now.utc] } }
  named_scope :active, :conditions => {:active => true}
  named_scope :inactive, :conditions => {:active => false}
  
  belongs_to :venue
  belongs_to :party
  belongs_to :photographer, :class_name => "User", :foreign_key => "photographer_id"
  has_one :flyer, :as => :obj, :dependent => :destroy
  has_many :guestlists, :dependent => :destroy, :order => "full_name asc"
  has_many :image_sets, :as => :obj, :dependent => :destroy, :order => "position"
  
  validates_presence_of       :party_id, :venue_id, :happens_at, :search_date
  validates_length_of         :synopsis,   :within => 3..1000, :allow_nil => true
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  def self.find_by_city_and_site(city_id, site_id)
    find(:all, :conditions => ["venues.city_id=? AND parties_sites.site_id=?", city_id, site_id], :include => [:party, :venue])
  end
  
  def self.images?
    self.image_sets_count > 0 ? true : false
  end
  
  def update_image_set_count
    self.update_attribute(:image_sets_count, image_sets.length)
  end
  
  def rss_title
    "#{self.local_time('date')}: #{self.party.title} at #{self.venue.name}"
  end
  
  def addToQueue(file, user_id)
	  extension = file.original_filename.sub(/.*?((\.tar)?\.\w+)$/, '\1')
	  upload_filename = "event_#{self.id}_#{user_id}#{extension}".downcase  			  
	  FileUtils.mv file.local_path, File.join(SETTING['image_server']['upload_dir'], upload_filename)
	  bg_task = BgTask.create(:obj_id => self.id, :obj_type => 'Event', :user_id => user_id, :status => "uploaded" )
	  return bg_task
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
    
  def access?(user_id,email)
    if self.photographer_id == user_id or self.party.photographer == email or self.party.user_id == user_id 
      return true
    end
    return false
  end
  
  def self.latest_image_sets(ids, opt={})
    option = {
      :limit => SETTING['limit'].to_i,
      :offset => 0
    }.merge(opt)
    
    find_by_sql(<<-EOL
    SELECT events.* FROM parties 
    LEFT OUTER JOIN venues ON venues.id = parties.venue_id 
    LEFT OUTER JOIN events ON events.party_id = parties.id 
    WHERE (venues.city_id in (#{ids}) AND events.image_sets_count > 0) 
    ORDER BY events.happens_at desc
    LIMIT #{option[:offset]}, #{option[:limit]}
    EOL
    )
  end
  
  def self.image_sets_by_date(ids, opt={})
    now = Time.now.utc
    option = {
      :year => now.year,
      :month => now.month,
      :day => now.day,
      :limit => SETTING['limit'].to_i,
      :offset => 0
    }.merge(opt)
    
    find_by_sql(<<-EOL
    SELECT events.* FROM parties 
    LEFT OUTER JOIN venues ON venues.id = parties.venue_id 
    LEFT OUTER JOIN events ON events.party_id = parties.id 
    LEFT OUTER JOIN parties_sites ON parties_sites.party_id = parties.id 
    LEFT OUTER JOIN sites ON sites.id=parties_sites.site_id 
    WHERE (venues.city_id in (#{ids}) AND events.image_sets_count > 0 AND events.search_date="#{option[:year]}-#{option[:month]}-#{option[:day]}") 
    ORDER BY events.happens_at asc
    LIMIT #{option[:offset]}, #{option[:limit]}
    EOL
    )
  end
  
  def set_uploaded(user_id)
    self.update_attributes({ :picture_uploaded => true, :picture_upload_time => Time.now.utc , :photographer_id => user_id })
    self.party.decrement!(:pics_left)
  end
  
  def reset_upload
    self.update_attributes({ :picture_uploaded => false, :picture_upload_time => nil , :photographer_id => nil, :image_sets_count => nil })
    self.party.increment!(:pics_left)
  end
  
  def before_update
    self.search_date = self.local_time('date')
    self.synopsis = synopsis.gsub(/<\/?[^>]*>/, "") unless synopsis.nil?
    self.image_sets_count = self.image_sets.size
  end
end