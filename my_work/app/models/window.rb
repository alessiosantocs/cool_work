# == Schema Information
# Schema version: 98
#
# Table name: windows
#
#  id      :integer(11)   not null, primary key
#  start   :time          
#  end     :time          
#  regular :boolean(1)    
#

class Window < ActiveRecord::Base
  has_many :stops
  belongs_to :assignments
  
  def self.find_all_regular
    Window.find(:all, :conditions => ["regular = true"], :order => "id ASC")
  end
  
  def regular?
    self.regular == true
  end
  
  def that_contains_time(t)
    
  end
  
  def to_s()
    formatTime(self.start) + " - " + formatTime(self.end + 1.second)
  end
  
  def formatTime(time)
    hr = time.strftime("%I").to_i
    min = time.strftime("%M") == '00' ? '' : ':' + time.strftime("%M") 
    ampm = time.strftime("%p").downcase
    hr.to_s + min + ampm
  end
  
  def prior_to_s
    "Before " + self.start.strftime('%I').to_i.to_s + self.start.strftime('%p').downcase
  end
  
  def after_to_s
    "After " + (self.end + 1.second).strftime('%I').to_i.to_s + self.end.strftime('%p').downcase
  end
end



#old shift code:

# class Shift < ActiveRecord::Base
#   has_many :assignments
#   has_many :orders, :foreign_key => :delivery_time
#   has_many :orders, :foreign_key => :pickup_time
#   
#   #attr_accessible :start, :end, :day_of_week, :recurring, :regular, :day, :day_mask
#   
#   #def validate
#     #errors.add(:shift, "cannot use both day and day_mask") if self.day and self.day_mask
#     #errors.add(:shift, "specific dates cannot be recurring, use day_of_week") if self.day and self.recurring
#     #errors.add(:day_of_week, "is invalid") unless ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"].include? self.day_of_week.downcase
#   #end
#   
#   def after_save
#     self.reload #force uniform times, since ruby Time object has a date component :-/
#   end
# 
#   def overlaps shift
#     #if self.same_day_as shift
#       return true unless self.end < shift.start or self.start > shift.end
#     #end
#   end
#   
#   # def same_day_as shift
#   #     if self.recurring and self.day_of_week
#   #       return true if self.day_of_week == shift.day_of_week
#   #       return true if defined? shift.day and shift.day and self.day_of_week.downcase == @@day_array[shift.day.wday]
#   #     elsif self.day
#   #       return true if self.day == shift.day
#   #       return true if shift.recurring and shift.day_of_week and @@day_array[self.day.wday] == shift.day_of_week
#   #     end
#   #   end
#   
#   # def weekend?
#   #   if self.day
#   #     [0,6].include? self.day.wday
#   #   elsif self.day_of_week
#   #     ["saturday", "sunday"].include? self.day_of_week.downcase
#   #   end
#   # end
#   # def weekday?
#   #   not self.weekend?
#   # end
#   
#   def self.find_regular_by_time(t)
#     Shift.find(:first, :conditions => ['regular = true AND ? > start AND ? < end', t.strftime("%H:%M:%S"), t.strftime("%H:%M:%S")])#' AND day_of_week = ?', t.strftime("%H:%M:%S"), t.strftime("%H:%M:%S"), @@day_array[t.wday] ] )
#   end
#   
#   def self.regular_shifts
#     Shift.find_all_by_regular(true)
#   end
#     
#   @@day_array = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
#   
#   #aliases/convenience
#   #def self.day_array
#   #  @@day_array
#   #end
#   def regular?
#     self.regular
#   end
#   def recurring?
#     self.recurring
#   end
# end
