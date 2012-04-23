require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < Test::Unit::TestCase
  fixtures :orders
  
  def setup
    @order = Order.find 1
  end
  
  def test_should_create_picture
    o = create_order()
    assert o.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Order.count
  end

  def test_destroy
    @order.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Order.find @order.id }
  end
  
  def test_validate
    assert_equal 1, @order.id
    @order.full_name = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@order.save
    assert_equal 1, @order.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Order, @order
    assert_equal 1, @order.id
    assert_equal 2, @order.user_id
    assert_equal 'Jisha Obukwelu', @order.full_name
    assert_equal '4 South Pinehurst Avenue #4F', @order.address
    assert_equal "New York", @order.city
    assert_equal 'NY', @order.state
    assert_equal 'us', @order.country
    assert_equal '10033', @order.postal_code
    assert_equal '917-674-5655', @order.phone
    assert_equal 9.00, @order.total
    assert_equal "Visa", @order.cc_type
    assert_equal "0123", @order.cc_last4
    assert_equal "Completed", @order.payment_status
    assert_equal nil, @order.void_confirmation_number
    assert_equal "192.12.11.1", @order.ip_address
    assert_equal nil, @order.response
    assert_equal nil, @order.notes
  end
  
  def test_these_properties
    o = create_order(:user_id => nil)
    assert o.errors.on(:user_id)
    o = create_order(:full_name => nil)
    assert o.errors.on(:full_name)
    o = create_order(:address => nil)
    assert o.errors.on(:address)
    o = create_order(:city => nil)
    assert o.errors.on(:city)
    o = create_order(:state => nil)
    assert o.errors.on(:state)
    o = create_order(:postal_code => nil)
    assert o.errors.on(:postal_code)
    o = create_order(:total => nil)
    assert o.errors.on(:total)
    o = create_order(:cc_type => nil)
    assert o.errors.on(:cc_type)
    o = create_order(:cc_last4 => nil)
    assert o.errors.on(:cc_last4)
    o = create_order(:payment_status => nil)
    assert o.errors.on(:payment_status)
  end
  
  protected
  def create_order(options = {})
    Order.create({ 
      :user_id => 1,
      :full_name => "Samuel Obukwelu",
      :address => 'PO Box 1454',
      :city => "New York",
      :state => "NY",
      :postal_code => "10027",
      :country => "us",
      :postal_code => '10027',
      :phone => nil,
      :total => 120.00,
      :cc_type => 'Mast',
      :cc_last4 => '0005',
      :payment_status => 'Pending',
      :void_confirmation_number => nil,
      :ip_address => "98.77.99.1",
      :response => nil,
      :notes => nil}.merge(options))
  end
end
