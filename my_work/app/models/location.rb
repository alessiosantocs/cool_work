# == Schema Information
# Schema version: 98
#
# Table name: locations
#
#  id          :integer(11)   not null, primary key
#  target_id   :integer(11)   
#  target_type :string(255)   
#

class Location < ActiveRecord::Base
  has_many :assignments
  has_many :zone_assignments
  has_many :zones, :through => :zone_assignments
  
  belongs_to :target, :polymorphic => true
  belongs_to :serviced_zip, :foreign_key => :target_id
  belongs_to :building, :foreign_key => :target_id
  belongs_to :zone, :foreign_key => :target_id
  belongs_to :area, :foreign_key => :target_id
  
  LocationHierarchy = [Address, Building, ServicedZip, Zone]
  
  def is_in(superzone)
    if superzone.class == Location
      superzone = superzone.target
    end
    if self.target == superzone
      return true
    end
    me = LocationHierarchy.index(self.target.class)
    sup = LocationHierarchy.index(superzone.class)
    if sup < me
      return false
    end
    parent = self.target
    until me == sup
      parent = parent.parent_location
      if parent == superzone or (parent.include?(superzone) if parent.class == Array)
        return true
      end
      me += 1
    end
    return false
  end
  
  def concords_with(loc)
    my_building = self.location.target.building if self.location.target_type == "Address"
    my_building = self.location.target if self.location.target_type == "Building"
    target_building = loc.location.target.building if loc.location.target_type == "Address"
    target_building = loc.location.target.target if loc.location.target_type == "Building"
    
    #puts my_building, '<-->', target_building, '==>', my_building == target_building
    
    return true if my_building == target_building
    false
  end
  
  def contains(subzone)
    if subzone.class == Location
      subzone = subzone.target
    end
    subzone.location.is_in(self.target)
  end
  
  def density
    self.target.density
  end
  
  def available_services
    services = Service.find(:all)
    available = []
    services.each do |s|
      available << s if s.area_of_availability.nil? or self.is_in(s.area_of_availability)
    end
    available
  end
  
  def get_schedule(date)
    Schedule.for(self.id, date)
  end
  
  def todays_schedule
    self.get_schedule(Date.today)
  end
  def tomorrows_schedule
    self.get_schedule(Date.tomorrow)
  end
  # is this useful, or should it be next_7_days_schedule?
  def this_weeks_schedule
     schedule = []
     [0,1,2,3,4,5,6].each do |i|
       schedule << self.get_schedule(Date.today + i.days)
     end
     schedule
  end
    
  
  def self.find_by_zip(zip)
    ServicedZip.find_by_zip(zip).location
  end
  #self.find_by_serviced_zip = self.find_by_zip #need to change to proc?
  
  def self.find_building(building)
    Building.find(building).location
  end
  
  def self.find_address(address)
    Address.find(address).location
  end
  
  def self.find_zone(zone)
    Zone.find(zone).location
  end
  
  def to_s
    self.target_type + self.target.to_s
  end
  
  def location
    self
  end
end
