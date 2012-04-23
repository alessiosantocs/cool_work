# == Schema Information
# Schema version: 98
#
# Table name: bins
#
#  id              :integer(11)   not null, primary key
#  order_part_id   :integer(11)   
#  tracking_number :string(255)   
#  area_id         :integer(11)   
#  full            :boolean(1)    
#  created_at      :datetime      
#  updated_at      :datetime      
#  position        :integer(11)   
#  destination     :integer(11)   
#

class Bin < ActiveRecord::Base
  belongs_to :order_part
  has_many :order_items
  belongs_to :area
  belongs_to :position, :class_name => 'Area'
  
  @@NUMBER_FORMAT = /^B\d+$/
  tracking_number_scheme = '^B\d+$'

  def position=(val)
    write_attribute(:position, val.id)
    self.save!
  end
  def position
    Area.find(read_attribute(:position))
  end
  
  def self.open(bin_no)
    return Bin.find_or_create_by_tracking_number(:tracking_number => bin_no) if bin_no =~ @@NUMBER_FORMAT
    false
  end
  
  def empty?
    return true if self.order_items == nil
    return true if self.order_items.size == 0
    false
  end
  
  def close()
    if self.empty?
      Bin.delete(self)
    else
      raise "Bin not Empty!"
    end
  end
  
  def self.close(bin_no)
    if Bin.find_by_tracking_number(bin_no).empty?
      Bin.delete(bin_no)
    else
      raise "Bin not empty!"
    end
  end
  
  def add(item_serial_no)
    if Scannable.scan(item_serial_no).class == OrderItem
      OrderItem.find_by_
    elsif
      raise "Bins may only contain order items"
    end
  end
  
  def remove(item_serial_no)
    #disassociate order_item with this bin
  end
  
  def self.where?(bin_no)
    Bin.find_by_tracking_number(bin_no).area.name
  end
  
  def where?
    self.area.name
  end
  
  def move_to(area)
    #puts "Moving bin ##{self.id}/#{self.tracking_number} to #{area.name}"
    self.position = area
    self.save!
    self.order_items.each do |item|
      #puts "area to move to: #{area.id}"
      item.position = area
      #puts "item position: #{item.position.id}"
      item.save!
    end
    self.save!
  end
  
  def item_count
    self.order_items.size
  end
  
  def full?
    self.full
  end
  
  def size
    self.order_items.size
  end
  
  # def scan(area)
  #   self.position = area
  #   self.order_items.each do |oi|
  #     oi.scan(area)
  #   end
  # end
  def self.number_format
    @@NUMBER_FORMAT
  end
  
  def active?
    
  end
  
  def contents
    self.order_items
  end
  
end
