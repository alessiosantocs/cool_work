# == Schema Information
# Schema version: 98
#
# Table name: areas
#
#  id         :integer(11)   not null, primary key
#  factory_id :integer(11)   
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Area < ActiveRecord::Base
  has_many :bins
  has_many :stands
  has_many :order_parts
  has_many :order_items
  has_many :areas, :as => :links #is it worth tracking this?
  
  def scan(number)
    
  end
  
  def receive(item)
    #if item has a method scan(), call scan() for current area
  end

  def bins_here
    Bin.find_all_by_position(self)
  end
  
  def racks_here
    Stand.find_all_by_position(self)
  end
  
end
