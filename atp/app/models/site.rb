class Site < ActiveRecord::Base
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :parties
  
  validates_uniqueness_of     :short_name, :full_name, :url
  validates_presence_of       :short_name, :full_name, :url
  validates_length_of         :short_name, :is => 3
  validates_format_of         :short_name, :with => /^([A-Za-z]+)$/i
  validates_length_of         :full_name, :within => 3..25
  validates_length_of         :url, :within => 7..128
  
  class << self
    def blank(options={})
      new({
        :active => true
      }.merge(options))
    end
  
    def active
      find :all, :conditions => ("active = true")
    end
  end
  
  def events_with_pics(time=5.days.ago, reload=false)
    cities = City.active.collect{|c| c.id }
    @events_with_pics = nil if reload
    
    @events_with_pics ||= Event.find_by_sql <<-EOL
    SELECT events.* FROM events 
      INNER JOIN venues ON events.venue_id = venues.id 
      WHERE venues.city_id in (#{cities.join(',')}) AND events.picture_uploaded=1 AND events.happens_at > '#{time.db}' AND events.image_sets_count > 0
      ORDER BY events.happens_at desc
      limit #{SETTING['www']['events']}
    EOL
  end
end