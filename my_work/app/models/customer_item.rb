# == Schema Information
# Schema version: 98
#
# Table name: customer_items
#
#  id              :integer(11)   not null, primary key
#  customer_id     :integer(11)   
#  item_type_id    :integer(11)   
#  brand           :string(255)   
#  color           :string(255)   
#  value           :decimal(9, 2) 
#  material        :string(255)   
#  service_id      :integer(11)   
#  instructions_id :integer(11)   
#  tracking_number :string(255)   
#  is_temporary    :boolean(1)    
#  size            :string(10)    
#  premium         :boolean(1)    
#

class CustomerItem < ActiveRecord::Base
  belongs_to :customer
  belongs_to :item_type
  belongs_to :instructions
  has_one :order_item
  
  @@NUMBER_FORMAT = /(0|1)\d{19}/
  
  def self.lookup(tracking_number)
    CustomerItem.find_by_tracking_number(tracking_number)
  end
  
  def assign_tracking_number(temporary = true)
    temp_digit = 0
    temp_digit = 1 if temporary
    
    cus = self.customer.id.to_s.rjust(6, '0') if self.customer
    string_sans_check = temp_digit.to_s + cus.to_s + self.id.to_s.rjust(8, '0')
    tracking_number = string_sans_check + self.class.check_digit(string_sans_check).to_s
    write_attribute(:tracking_number, tracking_number)
  end
  
  def check
    self.class.check_check_digit(self.tracking_number)
  end
  
  def special_handling
    special = ''
    special += "<b>Color:</b> #{color}, " if !color.blank? 
    special += "<b>Brand:</b> #{brand}, " if !brand.blank? 
    special += "<b>Size:</b> #{size}, " if !size.blank? 
    special += "<b>Premium:</b> #{premium}, "
    special += "<b>Instructions:</b> #{instructions.text}" if instructions and !instructions.text.blank?
    special
  end
  
  def instruction_text
    instruction = Instructions.find(:first, :conditions => ['id = ?', instructions_id])
    instruction.nil? ? '' : instruction.text 
  end
  #function to compute a check digit given a string of numbers and to validate that a string of numbers matches its check digit.
  #this is not the appropriate place for these functions, but here they'll stay until I can figure out where to put them.
  private
  def self.check_digit(numeric_string)
    odds = 0
    evens = 0
    #note: odds and evens are intentionally crossed in the following loop
     (0..numeric_string.length-1).to_a.each do |i|
      c = numeric_string[i]
      c -= 48 if c.class == Fixnum
      if i.odd?
        evens += c.to_i
      else
        odds += c.to_i
      end
    end
    check_digit = (10 - ((3*odds + evens) % 10)) % 10
    return check_digit
  end
  
  def self.check_check_digit(numeric_string)
    last_digit = numeric_string[numeric_string.length-1]
    last_digit = (last_digit - 48).to_s if last_digit.class == Fixnum
    self.check_digit(numeric_string[0...numeric_string.length-1]).to_s == last_digit
  end
  
  def self.premium
    val = read_attribute(:premium)
    val = order_item.order.premium if val.nil? and !order_item.nil?
    val
  end
end
