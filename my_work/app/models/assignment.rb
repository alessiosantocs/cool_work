# == Schema Information
# Schema version: 98
#
# Table name: assignments
#
#  id          :integer(11)   not null, primary key
#  driver_id   :integer(11)   
#  truck_id    :integer(11)   
#  status      :string(20)    
#  date        :date          
#  location_id :integer(11)   
#  position    :integer(2)    
#

class Assignment < ActiveRecord::Base
  has_many :requests
  has_many :windows
  belongs_to :truck
  belongs_to :driver
  belongs_to :location
  
  def self.reserve(date, truck, driver, location_id)
    a = Assignment.new
    a.date = date
    a.truck = truck
    a.driver = driver
    a.location_id = location_id
    a.status = :reserved
    a.windows = Window.find_all_regular
    a.save!
    a
  end
  
  def validate
    #driver can't be in two places at once
    
    #truck can't be in two places at once
  end
  
end
