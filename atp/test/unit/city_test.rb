require File.dirname(__FILE__) + '/../test_helper'

class CityTest < Test::Unit::TestCase
  fixtures :cities
  
  def setup
    @city = City.find 1
  end
  
  def test_should_create_city
    s = create_city()
    assert_equal 3, City.count
  end
  
  def test_count_my_fixtures
    assert_equal 3, City.count
    assert_equal 2, City.active.length
  end

  def test_destroy
    @city.destroy
    assert_raise(ActiveRecord::RecordNotFound) { City.find @city.id }
  end
  
  def test_validate
    assert_equal 1, @city.id
    @city.short_name = '123'
    assert !@city.save
    assert_equal 1, @city.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of City, @city
    assert_equal 1, @city.id
    assert_equal 'nyc', @city.short_name
    assert_equal 'New York City', @city.full_name
    assert_equal true, @city.active
  end
  
  def test_these_properties
    # first, let's try a few passwords that should fail
    s = create_city(:short_name => nil)
    assert s.errors.on(:short_name)
    s = create_city(:full_name => nil)
    assert s.errors.on(:full_name)
  end
  
  protected
  def create_city(options = {})
    City.create({ 
      :short_name => 'hou', 
      :full_name => 'Houston',
      :active => true }.merge(options))
  end
end
