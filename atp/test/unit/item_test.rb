require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
  fixtures :items
  
  def setup
    @item = Item.find 1
  end
  
  def test_should_create_picture
    i = create_item()
    assert i.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Item.count
  end

  def test_destroy
    @item.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Item.find @item.id }
  end
  
  def test_validate
    assert_equal 1, @item.id
    @item.name = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@item.save
    assert_equal 1, @item.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Item, @item
    assert_equal 1, @item.id
    assert_equal "Days", @item.name
    assert_equal "Advertise to our audience of hundreds of thousands of visitors", @item.description
    assert_equal 3, @item.price
    assert_equal true, @item.active
  end
  
  def test_these_properties
    i = create_item(:name => nil)
    assert i.errors.on(:name)
    i = create_item(:description => nil)
    assert i.errors.on(:description)
    i = create_item(:price => nil)
    assert i.errors.on(:price)
    i = create_item(:active => nil)
    assert i.errors.on(:active)
  end
  
  protected
  def create_item(options = {})
    Item.create({ 
      :name => "AD 120x120 px Square",
      :description => 'Some funn shit!!!',
      :price => 4.00,
      :active => true}.merge(options))
  end
end