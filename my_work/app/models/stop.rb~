# == Schema Information
# Schema version: 98
#
# Table name: stops
#
#  id          :integer(11)   not null, primary key
#  location_id :integer(11)   
#  slots       :integer(11)   
#  date        :date          
#  complete    :boolean(1)    
#  window_id   :integer(11)   
#

class Stop < ActiveRecord::Base
  belongs_to :window
  has_many :requests
  #belongs_to :serviced_zip, :foreign_key => :location_id
  belongs_to :location
  
  def initialize(*params)
    super(*params)
    self.slots = 0 unless self.slots
  end
  
  def serviced_zip
    self.location.serviced_zip
  end
  
  def make_request(order, type, doorman = false) #type in {:pickup, :delivery}
    order = Order.find(order) if order.class == Fixnum
    raise Exception, "second argument must be :pickup or :delivery" if type != :pickup and type != :delivery
    order.pickup.destroy   if type == :pickup   and order.pickup
    order.delivery.destroy if type == :delivery and order.delivery
    r = Request.create(:stop => self, :with_doorman => doorman, :takes_slot => !self.concords_with(order.customer.primary_address), :for => type.to_s, :order => order)
    r.takes_slot = false if order.customer.is_building
    order.requests << r
    order.save!
    r.save!
  end
  
  def negative?
    slots_left < 0
  end
  
  def available?
    slots_left > 0
  end
  
  def available_or_concords_with(address)
    slots_left > 0 or concords_with(address)
  end
  
  def concords_with(address)
    self.requests.each do |r|
      if r.concords_with(address)
        return true
      end
    end
    return false
  end
  
  def error?
    # implement error conditions
    if self.request_count > self.slots.to_i + self.concordant_request_count
      return true
    end
    false  
  end
  
  def closed?
    complete || self.slots_left < 0 
  end
  
  def add_slot
    self.slots += 1
  end
  def add_slots(n)
    self.slots += n
  end
  
  def remove_slot
    self.slots -= 1
  end
  def remove_slot(n)
    self.slots -= n
  end
  
  def slots_left
    # # of slots minus # of requests against this stop.
    return self.slots.to_i - self.isolated_request_count
  end
  
  def slot_available?
    slots_left > 0
  end
  
  def requests
    result
    for req in self.requests
      result << req if req.order.status != 'incomplete'
    end
    result
  end
  
  def request_count
    self.requests.size
  end
  
  def requests
    Request.find_all_by_stop_id(self.id)
  end
  
  def isolated_request_count
    #Request.find_by_sql("SELECT COUNT(*) FROM requests WHERE id = " + self.id + " AND takes_slot = ")
    Request.find(:all, :conditions => ["stop_id = ? AND takes_slot = ?", self.id, true]).size
  end
  
  def concordant_request_count
    Request.find(:all, :conditions => ["stop_id = ? AND takes_slot = ?", self.id, false]).size
  end
  
end
