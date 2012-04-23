require File.dirname(__FILE__) + '/../test_helper'

class RegionTest < Test::Unit::TestCase
  fixtures :regions
  
  def setup
    @region = Region.find 1
  end
  
  def test_should_create_region
    r = create_region()
    assert r.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Region.count
    assert_equal 2, Region.active.length
  end

  def test_should_require_name
    r = create_region(:name => nil)
    assert r.errors.on(:name)
  end

  def test_destroy
    @region.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Region.find @region.id }
  end
  
  def test_validate
    assert_equal 1, @region.id
    @region.name = 'as'
    assert !@region.save
    assert_equal 1, @region.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Region, @region
    assert_equal 1, @region.id
    assert_equal 'New York City', @region.name
    assert_equal true, @region.active
  end
  
  protected
  def create_region(options = {})
    Region.create({ 
      :name => 'Boston',
      :active => false }.merge(options))
  end
end
