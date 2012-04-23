require File.dirname(__FILE__) + '/../test_helper'

class GuestlistTest < Test::Unit::TestCase
  fixtures :guestlists
  
  def setup
    @guestlist = Guestlist.find 1
  end
  
  def test_should_create_guestlist
    g = create_guestlist()
    assert g.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 2, Guestlist.count
  end

  def test_destroy
    @guestlist.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Guestlist.find @guestlist.id }
  end
  
  def test_validate
    assert_equal 1, @guestlist.id
    @guestlist.full_name = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@guestlist.save
    assert_equal 1, @guestlist.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Guestlist, @guestlist
    assert_equal 1, @guestlist.id
    assert_equal 1, @guestlist.event_id
    assert_equal 1, @guestlist.user_id
    assert_equal "Micheal Baxter", @guestlist.full_name
    assert_equal 5, @guestlist.number_of_guests
  end
  
  def test_these_properties
    g = create_guestlist(:event_id => nil)
    assert g.errors.on(:event_id)
    g = create_guestlist(:full_name => nil)
    assert g.errors.on(:full_name)
    g = create_guestlist(:user_id => nil)
    assert g.errors.on(:user_id)
  end
  
  protected
  def create_guestlist(options = {})
    Guestlist.create({ 
      :event_id => 42,
      :user_id => 122,
      :full_name => "Slim Pickens",
      :number_of_guests => nil}.merge(options))
  end
end
