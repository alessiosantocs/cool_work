# == Schema Information
# Schema version: 98
#
# Table name: services
#
#  id                   :integer(11)   not null, primary key
#  name                 :string(255)   
#  description          :text          
#  min_length           :integer(11)   not null
#  rushable             :integer(11)   default(0), not null
#  is_itemizeable       :boolean(1)    
#  is_detailable        :boolean(1)    
#  is_weighable         :boolean(1)    
#  area_of_availability :integer(11)   
#  image_url            :string(255)   default("other.jpg")
#

class Service < ActiveRecord::Base
  has_many :item_types, :through => :prices
  has_many :prices
  has_one :location, :as => :area_of_availability
  has_many :promotion_services
  
  def applicable_item_types
    ItemType.find(:all, :select => ["item_types.*, prices.is_active"], :from => ["prices, item_types"], :conditions => ["prices.item_type_id = item_types.id AND prices.service_id = ? ", self.id], :order => 'name')
  end
  
  def itemizeable?
    self.is_itemizeable
  end
  
  def detailable?
    self.is_detailable
  end
  
  def weighable?
    self.is_weighable
  end
  
  def metric
    if self.is_weighable
      return "/lb"
    else
      return "ea."
    end
  end

  def self.active_services
    return self.find(:all,:conditions=>"is_active = 1 " )
  end
end
