class City < ActiveRecord::Base
  has_many :venues
  has_and_belongs_to_many :ads
  has_many :cover_images, :dependent => :destroy
  belongs_to :region
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  def events_with_pics(reload=false)
    @events_with_pics = nil if reload
    @events_with_pics ||= Event.count_by_sql("SELECT COUNT(events.id) FROM events	INNER JOIN venues ON events.venue_id = venues.id WHERE venues.city_id = #{self.id} AND events.picture_uploaded=1")
  end
  
  validates_uniqueness_of     :short_name, :full_name
  validates_presence_of       :short_name, :full_name, :region_id
  validates_length_of         :short_name,    :is => 3
  validates_length_of         :full_name,     :within => 3..25
  validates_format_of         :short_name, :with => /^([A-Za-z]+)$/i
end