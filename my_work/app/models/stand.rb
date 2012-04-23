# == Schema Information
# Schema version: 98
#
# Table name: stands
#
#  id              :integer(11)   not null, primary key
#  name            :string(255)   
#  area_id         :integer(11)   
#  position        :integer(11)   
#  destination     :integer(11)   
#  tracking_number :string(255)   
#  created_at      :datetime      
#  updated_at      :datetime      
#  order_part_id   :integer(11)   
#

class Stand < ActiveRecord::Base
  belongs_to :order_part
  has_many :order_items
  belongs_to :area
  has_one :position, :class_name => 'Area'
  
  @@NUMBER_FORMAT = /^R\d+$/
  tracking_number_scheme = '^R\d+$'
  
  def position=(val)
    write_attribute(:position, val.id)
    self.save!
  end
  def position
    Area.find(read_attribute(:position))
  end
  
  def self.open(rack_no)
    return Stand.find_or_create_by_tracking_number(:tracking_number => rack_no) if rack_no =~ @@NUMBER_FORMAT
    false
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
  
  def contents
    self.order_items
  end
  
  def empty?
    return true if self.order_items == nil
    return true if self.order_items.size == 0
    false
  end
  
  def full?
    self.full
  end
  
  def full
    false
  end
  
end
