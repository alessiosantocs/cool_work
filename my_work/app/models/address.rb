# == Schema Information
# Schema version: 98
#
# Table name: addresses
#
#  id               :integer(11)   not null, primary key
#  label            :string(20)    
#  building_id      :integer(11)   
#  customer_id      :integer(11)   
#  unit_designation :string(12)    
#  unit_number      :string(8)     
#  employee_id      :integer(11)   
#

class Address < ActiveRecord::Base
  belongs_to :customer
  belongs_to :employee
  belongs_to :building
  has_many :orders
  has_one :location, :as => :target
  
  @@UNIT_DESIGNATIONS = [nil, '', 'apt', 'suite', 'penthouse', 'floor', 'upper', 'lower', 'basement']
  
  def unit_designation_choices
    @@UNIT_DESIGNATIONS
  end
  
  def to_s
    self.building.to_s + ', ' + self.unit_number 
  end
  
  def formatted
    '<div>' + unit_number + '</div>' + building.formatted
  end
  
  def validate
    loc = Building.find(:first, :conditions => {:addr1 => self.addr1, :city => self.city, :state => self.state, :zip => self.zip})
    if loc
      self.building = loc
    end
  end
  
  def concords_with(loc)
    if loc.class == Address
      loc = loc.location
    end
    self.location.concords_with(loc)
  end
  
  def serviced?
    self.building.serviced?
  end
  
  def parent_location
    self.building
  end
  
  def is_in(superzone)
    self.location.is_in(superzone)
  end
  def contains(subzone)
    self.location.contains(subzone)
  end
  
  def density
    1
  end
  
  
  ##convenience accessors so you can refer to address.addr1 instead of address.building.addr1, etc.
  def addr1
    self.building.addr1
  end
  def addr1= (val)
    self.building.addr1 = val
  end
  
  def addr2
    self.building.addr2
  end
  def addr2= (val)
    self.building.addr2 = val
  end
  
  def city
    self.building.city
  end
  def city= (val)
    self.building.city = val
  end
  
  def state
    self.building.state
  end
  def state= (val)
    self.building.state = val
  end
  
  def zip
    self.building.zip
  end
  def zip= (val)
    self.building.zip = val
  end
  
end
