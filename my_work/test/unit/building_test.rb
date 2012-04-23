require File.dirname(__FILE__) + '/../test_helper'

class BuildingTest < ActiveSupport::TestCase
  fixtures :buildings, :serviced_zips, :addresses
  
  def test_initialize
    empty_location = Building.new
    param_set_1 = {:addr1 => "80 Morningside Ave.", :city => "Cresskill", :state => "NJ", :zip => "07626", :doorman => false}
    param_set_2 = {:addr1 => "80 Morningside Ave.", :city => "Closter", :state => "NJ", :zip => "07630", :doorman => false}
    loc1 = Building.new(param_set_1)
    loc2 = Building.new(param_set_2)
    
    #pp empty_location
    #pp loc1
    #pp loc2
    assert empty_location
    assert loc1
    assert loc2
    assert !empty_location.valid?
    assert loc1.valid?
    assert loc2.valid?
    
    assert loc1.new_record?
    assert loc2.new_record?
    
    loc1.save!
    loc2.save!
    
    assert !loc1.new_record?
    assert !loc2.new_record?
    
    loc3 = Building.new(param_set_1)
    
    assert loc3.new_record?
    #assert Building.find(:all).length == 2
  end
  
  def test_serviced_method
    z = ServicedZip.new(:zip => "99999")
        z.save!
        l = Building.new(:zip => "99999")
        assert l.serviced?
        l = Building.new(:zip => "00000")
    assert !l.serviced?
  end
  
  def test_can_access_fixtures
    assert buildings(:building1) != nil
    assert serviced_zips(:p2) != nil
  end
  
  def test_can_find
    assert Building.find(3)
    assert Building.find(3).city == "Hackerstown"
    assert_raise ActiveRecord::RecordNotFound do ServicedZip.find(4) end
  end
  
  def test_serviced?
    assert Building.find(1).serviced? == true
    assert !ServicedZip.find_by_zip("10004")
    assert !Building.find(4).serviced?
  end
  
  def test_parent_location
    Building.find(:all).each do |b|
      b.save!
    end
    b3 = Building.find(3)
    assert b3.parent_location == ServicedZip.find_by_zip(b3.zip)
  end
  
  def test_is_in
    b3 = Building.find(3)
    b3.save!
    z3 = ServicedZip.find_by_zip(b3.zip)
    z0 = ServicedZip.find(1)
    assert b3.is_in(z3)
    assert !b3.is_in(z0)
  end
  
  def test_contains
    #fixtures :addresses
    a1 = Address.find(1)
    a1.save!
    a1.building.save!
    assert a1.building.contains(a1)
    b2 = Building.find(2)
    b2.save!
    assert !b2.contains(a1)
  end
  
end