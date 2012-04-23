class Terminal
  @active_bin  = nil
  @active_rack = nil
  @active_item = nil
  
  attr_accessor(:area, :active_bin, :active_rack, :active_item)
  
  def self.for(area)
    t = Terminal.new
    t.area = Area.find_by_name(area) or Area.find(area)
    return t
  end
  
  def self.at(area)
    self.for(area)
  end
  
  def self.list
    Area.find(:all)
  end
  
  def open_bin?
    @active_bin or false
  end
  
  def open_rack?
    @active_rack or false
  end
  
  def open_bin(number)
    return false unless !self.open_bin? and !self.open_bin?
    bin = Bin.open(number)
    return false unless bin
    bin.position = self.area
    bin.save!
    @active_bin = bin
  end
  
  def open_rack(number)
    return false unless !self.open_rack? and !self.open_bin?
    rack = Stand.open(number)
    return false unless rack
    rack.position = self.area
    rack.save!
    @active_rack = rack
  end
  
  def scan_into_bin(number)
    raise Exception, "No bin open" unless @active_bin
    item = OrderItem.find_by_tracking_number(number)
    raise Exception, "No such order item -- bins may only contain order items" unless item
    @active_bin.order_part = item.order_part if @active_bin.empty?
    raise Exception, "Item already scanned into bin" if item.bin and item.bin.id == @active_bin.id
    #raise Exception, "Item belongs in bin " + item.bin.tracking_number.to_s if item.bin
    raise Exception, "Item does not belong in this bin" if item.order_part.id != @active_bin.order_part.id
    item.position = @active_bin.position
    @active_bin.order_items << item
    @active_bin.order_part = item.order_part
    if item.stand
      item.stand = nil
      item.save!
    end
    @active_bin.save!
  end
  
  def scan_onto_rack(number)
    raise Exception, "No rack open" unless @active_rack
    item = OrderItem.find_by_tracking_number(number)
    raise Exception, "No such order item -- racks may only contain order items" unless item
    @active_rack.order_part = item.order_part if @active_rack.empty?
    raise Exception, "Item already scanned onto rack" if item.stand and item.stand.id == @active_rack.id
    #raise Exception, "Item belongs on rack " + item.rack.tracking_number.to_s if item.rack
    raise Exception, "Item does not belong on this rack" if item.order_part.id != @active_rack.order_part.id
    item.position = @active_rack.position
    @active_rack.order_items << item    
    @active_rack.order_part = item.order_part
    if item.bin
      item.bin = nil
      item.save!
    end
    @active_rack.save!
  end
  
  def bin_full!
    @active_bin.full = true
    @active_bin.save!
    @active_bin = nil
  end
  
  def close_bin
    @active_bin.save!
    @active_bin = nil
  end
  
  def rack_full!
    @active_rack.full = true
    @active_rack.save!
    @active_rack = nil
  end
  
  def close_rack
    @active_rack.save!
    @active_bin = nil
  end
  
  def accept_bin(bin_no)
    bin = Bin.find_by_tracking_number(bin_no)
    bin.move_to(self.area)
  end
  
  def accept_rack(rack_no)
    rack = Stand.find_by_tracking_number(rack_no)
    rack.move_to(self.area)
  end
  
  def accept_order_part(part_no)
    order_part = OrderPart.find_by_tracking_number(part_no)
    order_part.move_to(self.area)
  end
  
  def find_mates(number = @active_item.tracking_number)
    item = OrderItem.find_by_tracking_number(number)
    return false unless item
    item.find_mates
  end
  
  def find_mates_container(number = @active_item.tracking_number)
    item = OrderItem.find_by_tracking_number(number)
    return false unless item
    item.find_mates_container
  end
  
  def scan_item(number)
    item = OrderItem.find_by_tracking_number(number)
    return false unless item
    item.position = self.area
    item.save()
    @active_item = item
  end
  
  def check_in_to(container_number = nil)
    container_number = @active_bin.tracking_number if container_number == nil and @active_bin
    container_number = @active_rack.tracking_number if container_number == nil and @active_rack
    container = Bin.find_by_tracking_number(container_number) or Stand.find_by_tracking_number(container_number)
    return false unless @active_item
    container.order_items << @active_item
    container.save!
    @active_item = nil
    container
  end
  
  def check_out(item_number)
    item = OrderItem.find(item_number)
    item.bin = nil
    item.stand = nil
    item.save!
  end
  
  def check_out_and_move_to(item_number, destination)
    item = check_out(item_number)
    item.destination = destination
    item.save!
  end
  
  def items_here
    OrderItem.find_all_by_position(self.area)
  end
  
  def parts_here
    OrderPart.find_all_by_position(self.area)
  end
  
  def bins_here
    Bin.find_all_by_position(self.area)
  end
  
  def racks_here
    Stand.find_all_by_position(self.area)
  end
  
  def name
    self.area.name
  end
  
  def self.identify(tracking_number)
    return :bin        if tracking_number =~ Bin.number_format
    return :stand       if tracking_number =~ Stand.number_format
    return :order_item if tracking_number =~ OrderItem.number_format
    return :order_part if tracking_number =~ OrderPart.number_format
  end
  def identify(tracking_number)
    Terminal.identify(tracking_number)
  end
end
  
  