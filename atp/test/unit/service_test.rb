require File.dirname(__FILE__) + '/../test_helper'

class ServiceTest < Test::Unit::TestCase
  fixtures :services
  
  def setup
    @service = Service.find 1
  end
  
  def test_should_create_service
    s = create_service()
    assert s.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 2, Service.count
  end

  def test_destroy
    @service.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Service.find @service.id }
  end
  
  def test_validate
    assert_equal 1, @service.id
    @service.name = 'Alexina Vasquez Performs Live at Show\nAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@service.save
    assert_equal 1, @service.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Service, @service
    assert_equal 1, @service.id
    assert_equal 5, @service.user_id
    assert_equal "Private Label Drinks LLC", @service.business_name
    assert_equal 5, @service.category_id
    assert_equal 'Rickey Henderson', @service.name
    assert_equal 'Joey@neocon.com', @service.email
    assert_equal "718-678-3512", @service.phone
    assert_equal "212-202-6164", @service.fax
    assert_equal 'www.loulou.com', @service.url
    assert_equal "PO Box 3244", @service.address
    assert_equal "New York", @service.city
    assert_equal "NY", @service.state
    assert_equal "10011", @service.postal_code
    assert_equal "us", @service.country
    assert_equal "Deliver branded water bottles", @service.description
    assert_equal false, @service.image
    assert_equal true, @service.published
  end
  
  def test_these_properties
    s = create_service(:user_id => nil)
    assert s.errors.on(:user_id)
    s = create_service(:business_name => nil)
    assert s.errors.on(:business_name)
    s = create_service(:category_id => nil)
    assert s.errors.on(:category_id)
    s = create_service(:name => nil)
    assert s.errors.on(:name)
    s = create_service(:email => nil)
    assert s.errors.on(:email)
    s = create_service(:phone => nil)
    assert s.errors.on(:phone)
    s = create_service(:description => nil)
    assert s.errors.on(:description)
    s = create_service(:city => nil)
    assert s.errors.on(:city)
    s = create_service(:state => nil)
    assert s.errors.on(:state)
    s = create_service(:country => nil)
    assert s.errors.on(:country)
  end
  
  protected
  def create_service(options = {})
    Service.create({ 
      :user_id => 1,
      :business_name => "Gecko Echo",
      :category_id => 1,
      :name => "Sylvia Ifejika",
      :email => 'sylvia@aol.com',
      :phone => '212-555-1212',
      :fax => nil,
      :url => nil,
      :address => nil,
      :city => "Carson City",
      :state => "NV",
      :postal_code => "87845",
      :country => 'us',
      :description => "By the VIP staircase",
      :image => false,
      :published => true}.merge(options))
  end
end