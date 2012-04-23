# == Schema Information
# Schema version: 98
#
# Table name: requests
#
#  id            :integer(11)   not null, primary key
#  for           :string(255)   
#  stop_id       :integer(11)   
#  created_at    :datetime      
#  updated_at    :datetime      
#  takes_slot    :boolean(1)    
#  order_id      :integer(11)   
#  assignment_id :integer(11)   
#  with_doorman  :boolean(1)    
#

class Request < ActiveRecord::Base
  belongs_to :stop
  belongs_to :order
  belongs_to :assignment
  
  def assigned?
    self.assignment != nil
  end
  
  def make_assignment(truck, position=nil)
    self.assignment.destroy if self.assignment 
    a = Assignment.new
    a.date = stop.date
    a.truck = truck
    a.position = position
    a.location_id = stop.location_id
    a.status = :reserved
    a.windows = Window.find_all_regular
    a.save!
    self.assignment = a
    save!
    a
  end
  
  def for_pickup?
    if self.for == "pickup"
      return true
    end
    return false
  end
  
  def for_delivery?
    if self.for == "delivery"
      return true
    end
    return false
  end
  
  def concords_with(address)
    self.order.customer.primary_address.concords_with(address) unless self.order.nil?
  end
  
  def window
    self.stop.window
  end
  
  def window=(val)
    self.stop.window=val
  end
end
