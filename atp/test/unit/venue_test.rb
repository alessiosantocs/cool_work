require File.dirname(__FILE__) + '/../test_helper'

class VenueTest < Test::Unit::TestCase
  fixtures :venues, :users
  
  def setup
    @venue = Venue.new
  end
  
  def test_should_create_venue
    assert create_venue.valid?
  end
  
  def test_should_update_name  
    v = venues(:first)
    v.update_attributes(:name => 'Benga Benga')
    v.reload
    assert_equal venues(:first).name, 'Benga Benga'
  end
  
  def test_should_update_address
    v = venues(:second)
    v.update_attributes(:address => '123 Walker Street', :cross_street => "Between 1st and 2nd avenue", :city => 'Houston', :state => 'TX', :postal_code => '78745')
    v.reload
    assert_equal v.address, '123 Walker Street'
    assert_equal v.city, 'Houston'
    assert_equal v.state, 'TX'
    assert_equal v.postal_code, '78745'
    assert_equal v.cross_street, "Between 1st and 2nd avenue"
  end
  
  def test_should_require_user_id
    v = create_venue(:user_id => nil)
    assert v.errors.on(:user_id)
  end
  
  def test_should_not_create_venue
    v = create_venue(:name => nil)
    assert v.errors.on(:name)
    v = create_venue(:address => nil)
    assert v.errors.on(:address)
    v = create_venue(:state => nil)
    assert v.errors.on(:state)
    v = create_venue(:country => nil)
    assert v.errors.on(:country)
  end
  
  def test_count_my_fixtures
    assert_equal 2, Venue.count
  end
  
  protected
  def create_venue(options = {})
    Venue.create({ 
      :name => 'Pacha',
      :user_id => 1,
      :address => '54 West 52st Street', 
      :postal_code => 10014, 
      :city => 'New York',
      :state => 'NY',
      :country => 'us',
      :cross_street => ''}.merge(options))
  end
end
