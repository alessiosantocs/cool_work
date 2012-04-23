# == Schema Information
# Schema version: 98
#
# Table name: order_parts
#
#  id              :integer(11)   not null, primary key
#  order_id        :integer(11)   
#  service_id      :integer(11)   
#  status          :string(255)   
#  created_at      :datetime      
#  updated_at      :datetime      
#  position        :integer(11)   
#  destination     :integer(11)   
#  tracking_number :string(255)   
#

class OrderPart < ActiveRecord::Base
  belongs_to :order
  has_many :order_items
  has_many :bins
  has_many :stands
  belongs_to :service
  has_one :position, :class_name => 'Area'
  
  @@NUMBER_FORMAT = /^P\d+$/
  
  def last_bin
    self.bins.each do |b|
      return b unless b.full
    end
    return nil
  end
  
  def last_rack
    self.stands.each do |r|
      return r unless r.full
    end
    return nil
  end
  
  def number_scanned_at(area)
    # container = self.last_bin or self.last_rack
    # if container.class == Bin
    #   count = self.bins.collect{|b| b.order_items.size}.sum
    # elsif container.class == Rack
    #   count = self.racks.collect{|b| b.order_items.size}.sum
    # end
    # count
    if area.class != Area
      area = Area.find_by_name(area) if area.class == String
      area = Area.find(area) if area.class == Fixnum
    end
    containers = area.bins_here | area.stands_here
    containers.collect{|c| c.order_items.size }.sum
  end
  
  def size
    self.order_items.size
  end
  
  def binned
    return true unless self.bins == []
  end
  
  def racked
    return true unless self.stands == []
  end
  
  def all_together?
    bins = false
    racks = false
    area = nil
    self.order_items.each do |item|
      area = item.position if area == nil
      return false if item.position != area
      return false if (item.bin and racks) or (item.stand and bins)
      bins  = true if item.bin
      racks = true if item.stand
      return false if item.bin == nil and item.stand == nil
    end
    true
  end
  
  def move_to(area)
    self.position = area
    self.order_items.each do |item|
      item.position = area
      item.save!
    end
    self.save!
  end
  
  def self.number_format
    @@NUMBER_FORMAT
  end
end
