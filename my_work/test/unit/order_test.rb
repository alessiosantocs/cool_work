require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < ActiveSupport::TestCase
  def test_order_creation
    user1 = User.new(:first_name => "Alexander", :last_name => "Girman", :login => "agirman", :password => "WDEzine", :password_confirmation => "WDEzine", :email => "project.AEG@gmail.com", :maiden => "Santos")
    user1.save!
    customer1 = Customer.new(:user => user1, :sex => "M", :dob => "20000101", :cell => "2015551212")
    
    pp customer1
    #@customer1 = customer1.save!
    address_1 = Address.new(:building => Building.new(:addr1 => "150 10th St.", :city => "Cresskill", :state => "NJ", :zip => "07626"))
    address_1.building.save!
    address_1.save!
    
    customer1.addresses << address_1
    customer1.save!
    customer1.addresses[0].save!
    pp customer1
    pp customer1.addresses
    pp customer1.addresses[0].building
    require 'db/migrate/populate_regular_shifts'
    pickup_time1 = Shift.find_regular_by_time(Time.local(0) + 10.hours + 15.minutes)
    delivery_time1 = Shift.find_regular_by_time(Time.local(0) + 3.days + 16.hours + 30.minutes)
    
    #pp @customer1
    pp Customer.find_by_name("Alexander Girman")
    pp Customer.find_by_name("Alexander Girman").addresses
    pp Customer.find_by_name("Alexander Girman").addresses[0].building
    
    order1 = Order.new(:customer => Customer.find_by_name("Alexander Girman"), :count => 3, :pickup_time => pickup_time1, :delivery_time => delivery_time1, :pickup_address => customer1.addresses[0], :delivery_address => customer1.addresses[0])
    order1.save!
    pp order1
    
    assert user1
    assert customer1
    assert pickup_time1
    assert delivery_time1
    assert order1
  end

end