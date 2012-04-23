class Party < ActiveRecord::Base
  has_and_belongs_to_many :sites
  belongs_to :user
  belongs_to :venue
  has_one :flyer, :as => :obj, :dependent => :destroy
  has_many :events, :order => "happens_at desc", :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  has_many :image_sets, :through => :events
  has_many :faves, :as => :obj, :dependent => :destroy
  acts_as_taggable
  acts_as_rateable
  acts_as_commentable
  acts_as_voteable
  
  attr_accessor :start_time, :end_time, :next_date
  
  validates_presence_of       :user_id, :venue_id, :title, :age_male, :age_female, :door_charge, :music, :description
  validates_length_of         :title,   :within => 3..50
  validates_length_of         :description,   :within => 3..1000
  validates_format_of      :start_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(AM|am|PM|pm)$/, :allow_nil => true
  validates_format_of      :end_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(AM|am|PM|pm)$/, :allow_nil => true
  # validates_format_of      :next_date, :with => /^([2][0]\d{2}-([0]\d|[1][0-2])-([0-2]\d|[3][0-1]))$/, :allow_nil => true
  
  class << self
    def blank(options={})
      ivar = new({
        :days_free => 7,
        :days_paid => 0,
        :pics_left => 0,
        :age_male => 2,
        :age_female => 2,
        :dress_code => 3,
        :premium => false,
        :comments_allowed => true,
        :active => true,
      }.merge(options))
      ivar.next_date = options[:next_date] unless options[:next_date].nil?
      ivar
    end
    
    def active
      find :all, :conditions => ("parties.active = true")
    end

    def recent_parties_by_city(ids, opt={})
      option = {
        :active => true,
        :limit => SETTING['limit'].to_i,
        :offset => 0
      }.merge(opt)

      find(:all, 
        :conditions => ["venues.city_id in (?) AND parties.active=? AND events.happens_at > ?", ids, option[:active], Time.now.utc], 
        :include=> [:venue, :events], 
        :order => "events.happens_at asc",
        :limit => option[:limit],
        :offset => option[:offset]
        )
    end

    def recur
      { "multiple" => "Weekly", "no" => "No"} #, "monthly" => "Monthly"
    end

    def dress_code
      { "0" => "Formal", "1" => "Semi-Formal", "2" => "Casual", "3" => "Chic", "4" => "Dress to Kill", "5" => "White T-Shirt/Blue Jeans", "6" => "Jerseys"}
    end

    def frequency
      ["day", "week", "month", "year"]
    end

    def wotm
      { "1" => "First", "2" => "Second", "3" => "Third", "4" => "Fourth"}
    end

    def dotw
      [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
    end

    def age
      { "0" => "18 and Under", "1" => "18 and Over", "2" => "21 and Over", "3" => "23 and Over", "4" => "25 and Over"}
    end

    def music
      {
        "4" => 'Acid Jazz',
        "5" => 'Alternative',
        "6" => 'Ambient',
        "2" => 'Bashment',
        "47" => 'Bhangra',
        "7" => 'Blues',
        "8" => 'Cabaret', 
        "9" => 'Calypso',
        "10" => 'Classics', 
        "11" => 'Country',
        "37" => 'Deep House',
        "12" => 'Disco',
        "43" => 'Downbeat House',
        "13" => 'Electronica',
        "40" => 'Filter House',
        "44" => 'Funk',
        "42" => 'Garage',
        "14" => 'Glam Rock',
        "15" => 'Hip-Hop',
        "46" => 'House',
        "16" => 'Industrial',
        "17" => 'Jungle',
        "18" => 'Latin',
        "31" => 'Latin Soul',
        "19" => 'Lounge',
        "20" => 'Metal',
        "21" => 'New Wave',
        "45" => 'NY Underground House',
        "22" => 'Old School',
        "38" => 'Progressive House',
        "23" => 'Psychedelic',
        "25" => 'Reggae',
        "24" => 'Rhythm and Blues',
        "35" => 'Rock\'n\'Roll',
        "34" => 'Salsa',
        "33" => 'Samba',
        "26" => 'Smooth Jazz',
        "39" => 'Soulful House',
        "32" => 'Spanish',
        "27" => 'Swing',
        "28" => 'Techno/Rave',
        "29" => 'Top 40',
        "36" => 'Trance',
        "41" => 'Tribal House',
        "30" => 'Trip-Hop'
      }
    end
  end
  
  def rss_title
    "#{self.title} at #{self.venue.name}"
  end
  
  def rss_description
    <<-EOL
    Host(s): #{self.hosted_by || 'none' }.
    Music: #{self.music}
    Location: #{self.venue.full_address}.
    Description:
    #{self.description}
    EOL
  end
  
  def access?(user_id,email)
    self.photographer == email or self.user_id == user_id 
  end
  
  def rsvp?
    self.rsvp_email.length > 0
  end
  
  def total_days
    self.days_free
  end
  
  def one_time?
    self.recur == 'no'
  end
  
  def photographer?(email)
    self.photographer == email
  end
  
  def get_photographer
    return nil if self.photographer.nil?
    if u = User.find_by_email(photographer)
      return u 
    end
  end

  def event
    return nil if current_event_id.nil?
    if event = Event.find_by_id(self.current_event_id)
      return event
    else
      return nil
    end
  end

  def past_events(offset=0,limit=SETTING['limit'])
    self.events.find(:all, :conditions=> ["events.happens_at < ?", Time.now.utc], :order => "happens_at desc", :offset => offset, :limit => limit)
  end

  def pictures(offset=0, limit=5)
    self.events.find :all, :conditions => ("events.image_sets_count > 0"), :order => "events.happens_at desc", :offset => offset, :limit => limit
  end
  
  def days
    days_free.to_i + days_paid.to_i
  end
  
  def current_flyer
    unless event.nil?
      event.flyer || flyer || nil
    else
      flyer || nil
    end
  end
  
  def date
    self.event.local_time('date')
  end
  
  def time
    self.event.local_time('12hr')
  end
  
  def create_new_event
    return nil if self.events.first.id == self.current_event_id and self.events.first.happens_at > 0.day.ago
    if self.events.first.id != self.current_event_id and self.events.first.happens_at > 0.day.ago
      self.event.update_attribute_with_validation_skipping(:active, false) unless self.event.nil?
      self.update_attribute_with_validation_skipping(:current_event_id, self.events.first.id )
      return true
    end
    happens_at = self.next_happens_at
    self.event.update_attribute_with_validation_skipping(:active, false) unless self.event.nil?
    tz = TzinfoTimezone.new( self.venue.time_zone )
    date = tz.utc_to_local( parse_time( happens_at ) )
    new_event = self.events.create({
      :venue_id => self.venue_id,
      :happens_at => happens_at.utc,
      :search_date => date.strftime("%Y-%m-%d"),
      :hosted_by => self.hosted_by,
      :comments_allowed => self.comments_allowed,
      :picture_uploaded => false,
      :active => true
    })
    self.update_attribute_with_validation_skipping(:current_event_id, new_event.id )
  end
  
  def next_happens_at(time=nil)
    if time.nil?
      time = self.past_events(0,1).first.happens_at
    end
    return time if time > 0.day.ago
    case self.recur
      when 'no', 'monthly'
        time
      when 'multiple'
        time = time.to_i
        time_eval = "#{self.timeframecount}.#{Party.frequency[self.tf]}.since(Time.at(#{time}))"
        t = eval(time_eval)
        time = Time.at(t)
        0.day.ago > time ? self.next_happens_at(time) : time
    end
  end
  
  def to_param
    "#{id}-#{[title, venue.name, venue.city_name, venue.state].join(' ').gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  protected
  def get_length_in_hours
    start_t = Time.parse(self.next_date + " " + self.start_time) 
    end_t = Time.parse(self.next_date + " " + self.end_time)
    case start_t <=> end_t
      when 1
        (24 - (start_t - end_t) / 3600 ).to_f
      when -1
        ((start_t - end_t) / 3600 ).to_f.abs
      when 0
        24
    end
  end
  
  def validate
    unless next_date.nil?
      unless start_time.nil? and end_time.nil?
        self.length_in_hours = get_length_in_hours
      else
        errors.add("start_time", "is not valid.") if start_time.nil?
        errors.add("end_time", "is not valid.") if end_time.nil?
      end
    end
  end
  
  def before_save
    if self.recur == 'multiple'
      self.tf             = 1
      self.timeframecount = 1
    end
  end
  
  def after_create
    #get timezone from selected venue
    tz = TzinfoTimezone.new(self.venue.time_zone)
    date = parse_time( next_date + " " + start_time )
    #create event
    new_event = self.events.create({
      :venue_id => self.venue_id,
      :happens_at => tz.local_to_utc( date ),
      :search_date => "#{date.year}-#{date.mon}-#{date.day}",
      :hosted_by => self.hosted_by,
      :comments_allowed => self.comments_allowed,
      :picture_uploaded => false,
      :active => true
    })
    if new_event
      #update party current_event_id
      self.update_attribute(:current_event_id, new_event.id)
    else
      self.search_date = ''
    end
    Audit.log(self, self.user.username, 'new', "New Party: #{self.title} at #{self.venue.name} (#{self.venue.city}, #{self.venue.state})")
  end
  
  def after_update
    unless start_time.nil? and end_time.nil?
      tz = TzinfoTimezone.new(self.venue.time_zone)
      date = Time.parse( next_date.to_s + " " + start_time.to_s)
      if self.event.active == true
        #use current event
        self.event.update_attributes({
          :party_id => self.id,
          :venue_id => self.venue_id,
          :happens_at => tz.local_to_utc( date ),
          :search_date => "#{date.year}-#{date.mon}-#{date.day}",
          :hosted_by => self.hosted_by
        })
      else
        #create new event
        new_event = self.events.create({
          :venue_id => self.venue_id,
          :happens_at => tz.local_to_utc( date ),
          :search_date => "#{date.year}-#{date.mon}-#{date.day}",
          :hosted_by => self.hosted_by,
          :comments_allowed => self.comments_allowed,
          :picture_uploaded => false,
          :active => true
        })
        if new_event
          #update party current_event_id
          self.update_attribute(:current_event_id, new_event.id)
        else
          self.search_date = ''
        end
      end
      self.toggle!(:active) if self.active == false
    end
    Audit.log(self, self.user.username, 'party', "Updated Party: #{self.title} at #{self.venue.name} (#{self.venue.city}, #{self.venue.state})")
  end
end