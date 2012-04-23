require File.dirname(__FILE__) + '/../test_helper'

class PersonalTest < Test::Unit::TestCase
  fixtures :profiles
  
  def setup
    @profile = Profile.find 1
  end
  
  def test_should_create_profile
    p = create_profile()
    assert p.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Profile.count
  end

  def test_destroy
    @profile.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Profile.find @profile.id }
  end
  
  def test_validate
    assert_equal 1, @profile.id
    @profile.full_name = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@profile.save
    assert_equal 1, @profile.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Profile, @profile
    assert_equal 1, @profile.id
    assert_equal 3, @profile.user_id
    assert_equal "Jisha's Card", @profile.title
    assert_equal "Jisha Obukwelu", @profile.full_name
    assert_equal '4 South Pinehurst Avenue #4F', @profile.address
    assert_equal "New York", @profile.city
    assert_equal "NY", @profile.state
    assert_equal "us", @profile.country
    assert_equal "10033", @profile.postal_code
    assert_equal '917-674-5655', @profile.phone
    assert_equal true, @profile.primary_profile
  end
  
  def test_these_properties
    p = create_profile(:user_id => nil)
    assert p.errors.on(:user_id)
    p = create_profile(:title => nil)
    assert p.errors.on(:title)
    p = create_profile(:full_name => nil)
    assert p.errors.on(:full_name)
    p = create_profile(:address => nil)
    assert p.errors.on(:address)
    p = create_profile(:city => nil)
    assert p.errors.on(:city)
    p = create_profile(:state => nil)
    assert p.errors.on(:state)
    p = create_profile(:postal_code => nil)
    assert p.errors.on(:postal_code)
    p = create_profile(:country => nil)
    assert p.errors.on(:country)
    p = create_profile(:country => '34dsadfasdfas')
    assert p.errors.on(:country)
  end
  
  protected
  def create_profile(options = {})
    Profile.create({ 
      :user_id => 1,
      :title => "Ada's Card",
      :full_name => "Samuel Obukwelu",
      :address => 'PO Box 1454',
      :city => "New York",
      :state => "NY",
      :postal_code => "10027",
      :country => "us",
      :primary_profile => true}.merge(options))
  end
end
