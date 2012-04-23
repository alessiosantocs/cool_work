# == Schema Information
# Schema version: 98
#
# Table name: item_types
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  icon        :string(255)   
#  carbon_cost :float         
#  water_cost  :float         
#

class ItemType < ActiveRecord::Base
  has_many :services, :through => :prices
  has_many :prices
  has_many :promotion_services
  validates_presence_of :name
  
  def available_services
    Service.find(:all, :select => ["services.*"], :from => ["services, prices"], :conditions => ["services.id = prices.service_id AND prices.item_type_id = ?", self.id])
  end
  
  def has_service?(service)
    available_services.collect{|a| a.name}.include?(service.name)
  end
  
  def <=>(other)
    services.id <=> services.first.id 
  end
end
