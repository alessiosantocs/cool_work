# == Schema Information
# Schema version: 98
#
# Table name: order_items
#
#  id               :integer(11)   not null, primary key
#  order_id         :integer(11)   
#  customer_item_id :integer(11)   
#  service_id       :integer(11)   
#  instructions_id  :integer(11)   
#  weight           :decimal(6, 2) default(1.0)
#  verified         :boolean(1)    
#  status           :string(255)   
#  processed        :boolean(1)    
#  position         :integer(11)   
#  destination      :integer(11)   
#  price            :decimal(9, 2) 
#  water_cost       :decimal(9, 2) 
#  carbon_cost      :decimal(9, 2) 
#  point_value      :integer(11)   
#  bin_id           :integer(11)   
#  rack_id          :integer(11)   
#  order_part_id    :integer(11)   
#  premium          :boolean(1)    
#  ls_starch        :boolean(1)    
#

class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :customer_item
  belongs_to :service
  belongs_to :order_part
  belongs_to :instructions
  belongs_to :destination, :class_name => 'Area'
  belongs_to :position,    :class_name => 'Area'
  belongs_to :bin
  belongs_to :stand
  
  #@@NUMBER_FORMAT = /^(0|1)\d{19}$/
  @@NUMBER_FORMAT = /^(0|1)\d+$/
  
  def customer_item_type
    customer_item.item_type  
  end
  
  def is_premium?
    self.order.premium || self.customer_item.premium || self.premium
  end 

  def is_itemizeable?
    item_service = service || Price.find(:first, :conditions => ["item_type_id = ?", self.customer_item.item_type_id]).service
    item_service.is_itemizeable
  end
  
  def is_weighable?
    item_service = service || Price.find(:first, :conditions => ["item_type_id = ?", self.customer_item.item_type_id]).service
    item_service.is_weighable?
  end
  
  def price
    unless read_attribute(:price)
      if self.service
        unless self.service.name == 'Wash and Fold'
          self.weight = 1 if self.weight == 0 or self.weight == nil
          return self.weight * Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.item_type, self.service]).price unless(self.order.premium || self.customer_item.premium || self.premium)
          return self.weight * Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.item_type, self.service]).premium
        else
          price_detail = Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.item_type, self.service])
          price = (self.order.premium || self.customer_item.premium || self.premium) ? price_detail.premium : price_detail.price 
          return [self.weight-10,0].max * price + price * 10
        end
      else
        return 0
      end
    end
    read_attribute(:price)
  end
  
  def plant_price
    customer_item = self.customer_item
    if customer_item.plant_price == 0.00
      if self.service
        unless self.service.name == 'Wash and Fold'
          self.weight = 1 if self.weight == 0 or self.weight == nil
          return self.weight * Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.item_type, self.service]).plant_price unless(self.order.premium || self.customer_item.premium || self.premium)
          return self.weight * Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.item_type, self.service]).plant_premium_price
        else
          price_detail = Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.item_type, self.service])
          price = (self.order.premium || self.customer_item.premium || self.premium) ? price_detail.plant_premium_price : price_detail.plant_price 
          return [self.weight-10,0].max * price + price * 10
        end
      else
        return 0
      end
    else
        return customer_item.plant_price.to_f
    end
  end
#   def price=(val)
#     val.blank? ? write_attribute(:price, nil) : write_attribute(:price, val)
#   end

  def premium
    return self.customer_item.premium unless read_attribute(:premium)
    return read_attribute(:premium)
  end
  
  def water_cost
    unless read_attribute(:water_cost)
      if self.service
        self.weight = 1 if self.weight == 0 or self.weight == nil
        return self.weight * Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.customer_item.item_type_id, self.service.id]).water
      else
        return 0
      end
    end
    read_attribute(:water_cost)
  end
  
  def carbon_cost
    unless read_attribute(:carbon_cost)
      if self.service
        self.weight = 1 if self.weight == 0 or self.weight == nil
        return self.weight * Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.customer_item.item_type_id, self.service.id]).carbon
      else
        return 0
      end
    end
    read_attribute(:carbon_cost)
  end
  
  def point_value
    unless read_attribute(:point_value)
      if self.service
        self.weight = 1 if self.weight == 0 or self.weight == nil
        return self.weight * Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.customer_item.item_type_id, self.service.id]).point_value
      else
        return 0
      end
    end
    read_attribute(:point_value)
  end
  
  # def verified
  #   write_attribute(:verified, true)
  #   self.status = 'received'
  # end
  
  def verified?
    self.verified == true
  end
  def verify!
    self.reload
    self.verified = true
    self.status = 'received'
    self.save!
  end
  
  def number
    self.customer_item.tracking_number
  end
  
  def self.find_by_tracking_number(number)
    OrderItem.find(:first,
                   :joins => 'INNER JOIN customer_items ON order_items.customer_item_id = customer_items.id',
    :conditions => ['customer_items.tracking_number = ?', number],
    :readonly => false,
    :order => 'id DESC'
    )
  end
  
  def missing!
    self.status = 'missing'
    self.order = nil
    self.save!
  end
  
  def where?
    self.class.where?(self.tracking_number)
  end
  
  def self.where?(tracking_no)
    item = OrderItem.find_by_tracking_number(tracking_no)
    return item.position.name + " " + self.container_type.to_s + " \#" + self.container_number.to_s
  end
  
  def move_to(area)
    self.position = area
    self.save!
  end
  
  def container_type
    if self.bin
      return :bin
    elsif self.stand
      return :stand
    end
  end
  
  def container_number
    if self.container_type == :bin
      return self.bin.tracking_number
    elsif self.container_type == :stand
      return self.stand.tracking_number
    end
  end
  
  def position=(val)
    write_attribute(:position, val.id) if val
    write_attribute(:position, nil) if val == nil
    self.save!
  end
  def position
    if read_attribute(:position)
      return Area.find(read_attribute(:position))
    else
      return nil
    end
  end
  
  # def find_mates
  #   target_container = self.order_part.last_rack || self.order_part.last_bin
  #   target_position  = target_container.position
  #   target_position.name.to_s + ' > ' + target_container.tracking_number.to_s
  # end
  
  def find_mates
    self.order_part.order_items
  end
  
  def find_mates_container
    self.order_part.last_stand or self.order_part.last_bin
  end
  
  #add cross-over functionality from customer_items for sanity's sake
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
  
  def assign_tracking_number
    self.customer_item.assign_tracking_number
  end
  def assign_tracking_number!
    self.customer_item.assign_tracking_number
    self.customer_item.save!
  end
  
  def item_type
    self.customer_item.item_type
  end
  
  def brand
    self.customer_item.brand
  end
  def color
    self.customer_item.color
  end
  def size
    self.customer_item.size
  end
  def value
    self.customer_item.value
  end
  def instructions_text
    if self.customer_item && self.customer_item.instructions && !self.customer_item.instructions.text.blank?
      self.customer_item.instructions.text
    else
      self.instructions.text if self.instructions 
    end
  end
  def material
    self.customer_item.material
  end
  def size
    self.customer_item.size
  end
  def tracking_number
    self.customer_item.tracking_number
  end
  def is_temporary
    self.customer_item.is_temporary
  end
  def brand=(val)
    self.customer_item.brand = (val)
  end
  def size=(val)
    self.customer_item.size = (val)
  end
  def color=(val)
    self.customer_item.color = (val)
  end
  def value=(val)
    self.customer_item.value = (val)
  end
  def instructions_text=(val)
    if self.instructions
      self.instructions.text = (val) 
    else
      self.instructions = Instructions.create!(:text => val)
    end
    if self.customer_item
      if self.customer_item.instructions
        self.customer_item.instructions.text = (val)
        self.customer_item.instructions.save!
      else
        self.customer_item.instructions = Instructions.create!(:text => val)
      end
    end
  end
  def material=(val)
    self.customer_item.material = (val)
  end
  def is_temporary=
    self.customer_item.is_temporary
  end
  def size=(val)
    self.customer_item.size=val
  end
  
  def self.number_format
    @@NUMBER_FORMAT
  end
  
  def ls_starch
    starch = read_attribute(:ls_starch) 
    starch.nil? ? self.order.customer.preferences.ls_starch : starch
  end
  
  def before_save
    if self.weight == 0
      self.weight = 1
    end
  end
  
  def get_weight
    price_detail = Price.find(:first, :conditions => ["item_type_id = ? AND service_id = ?", self.item_type, self.service])
#     price = (self.order.premium || self.customer_item.premium || self.premium) ? price_detail.premium : price_detail.price 
    return self.weight > 10 ? self.weight : 10
  end
end
