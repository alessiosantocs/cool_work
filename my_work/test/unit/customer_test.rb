require File.dirname(__FILE__) + '/../test_helper'

class BuildingTest < ActiveSupport::TestCase
#  fixtures :serviced_zips
  fixtures :customers
  
  def test_initialize
    empty_customer = Customer.new
    param_set_1 = {:sex => "M", :dob => "19910315", :cell => "2015551212", :accepted_terms => true}
    param_set_2 = {:sex => "F", :dob => "19850711", :home => "2125551212", :accepted_terms => true}
    c1 = Customer.new(param_set_1)
    c2 = Customer.new(param_set_2)
    
    assert empty_customer
    assert c1
    assert c2
    
    assert !empty_customer.valid?
    assert !c1.valid?
    assert !c2.valid?
    
    assert c1.new_record?
    assert c2.new_record?
    
    user_account_1 = {:first_name => "John", :last_name => "Doe", :login => "jdoe@domain.com", :email => "jdoe@gmail.com", :maiden => "Anyman", :password => "password", :password_confirmation => "password"}
    user_account_2 = {:first_name => "Jane", :last_name => "Doe", :login => "plainjane@domain.com", :email => "plainjane@gmail.com", :maiden => "Somebody", :password => "password", :password_confirmation => "password"}
    c1.user = User.new(user_account_1)
    c2.user = User.new(user_account_2)
    
    address_1 = Address.new({:building => Building.new({:addr1 => "20 County Rd.", :city => "Cresskill", :state => "NJ", :zip => 07626})})
    address_2 = Address.new({:unit_designation => "apt", :unit_number => "1E", :building => Building.new({:addr1 => "150 5th Ave.", :city => "New York", :state => "NY", :zip => "10015", :doorman => true})})
    
    address_1.save!
    address_2.save! 
    
    assert !c1.valid?
    assert !c2.valid?
    
    c1.addresses << address_1
    c2.addresses << address_2
    
    c1.save!
    c2.save!
    
    assert !c1.new_record?
    assert !c2.new_record?
    
    c3 = Customer.new(param_set_1)
    
    assert c3.new_record?
    #assert Customer.find(:all).length == 2
  end
  
  def test_world_fixtures
    assert customers(:cSussman)
    assert customers(:cStallman)
    u = customers(:cSussman).account
    assert u
    assert u.id == 4
  end
  
  def test_account_linkage
    assert customers(:cSussman).account.email == "sussman@mit.edu"
    assert customers(:cStallman).account.email == "rstallman@gnu.org"
  end
  
  def test_referrer
    assert customers(:cSussman).referrer.email == "rstallman@gnu.org"
  end
  
  
end