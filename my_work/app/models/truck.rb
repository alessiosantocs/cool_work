# == Schema Information
# Schema version: 98
#
# Table name: trucks
#
#  id             :integer(11)   not null, primary key
#  name           :string(255)   
#  capacity       :integer(11)   
#  active         :boolean(1)    
#  rate_mod       :integer(11)   
#  decommissioned :boolean(1)    
#  hex_color      :string(6)     default("CC3333")
#

class Truck < ActiveRecord::Base
  has_many :assignments
  
  #def is_available_for(shift)
  #  shifts = Assignment.find_all_shifts_by_truck(self.id)
  #  shifts.each do |s|
  #    return false if shift.overlaps(s)
  #  end
  #  true
  #end
  
  def open_on_date(date)
    todays_assignments = Assignment.find_all_by_truck_id_and_date(self, date)
    num_requests = 0
    todays_assignments.each do |a|
      num_requests += a.requests.count
    end
    self.capacity.to_i - num_requests
  end
  
  def assignments_for_date_and_locations(date, serviced_zips)
    serviced_zip = ServicedZip.find(:all)
    result = []
    serviced_zip.each do |z|
      assignments = Assignment.find_all_by_date_and_location_id_and_truck_id(date, z.location.id, id)
      result += assignments if assignments
    end
    result.sort_by{ |i| i.position.nil? ? 10000 : i.position.to_i }
  end
  
  def assign(date, location, driver = nil)
    new_assignment = Assignment.find_or_create_by_date_and_location_id(:date => date, :location_id => location.location)
    new_assignment.driver = driver if driver
    @assignments << new_assignment
  end
  
  def self.find_all_available()
    return Truck.find(:all, :conditions=>"active = TRUE")
  end
  
  def self.find_all_available_by_selection(selected_ids)
    return Truck.find(:all, :conditions => ['id IN (?) AND active = TRUE', selected_ids])
  end
end
