require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events
  
  def setup
    @event = Event.find 1
  end
  
  def test_should_create_event
    e = create_event()
    assert e.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Event.count
    assert_equal 1, Event.active.length
  end

  def test_destroy
    @event.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Event.find @event.id }
  end
  
  def test_validate
    assert_equal 1, @event.id
    @event.hosted_by = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@event.save
    assert_equal 1, @event.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Event, @event
    assert_equal 1, @event.id
    assert_equal 1, @event.party_id
    assert_equal 1, @event.venue_id
    assert_equal false, @event.pictures_exist
    assert_equal 0, @event.picture_count
    assert_equal nil, @event.photographer_id
    assert_equal 'Jisha and Shiji', @event.hosted_by
    assert_equal 'Lovely People', @event.synopsis
    assert_equal false, @event.flyer
    assert_equal true, @event.comments_allowed
    assert_equal false, @event.daylight_savings_time
    assert_equal true, @event.active
  end
  
  def test_these_properties
    e = create_event(:party_id => nil)
    assert e.errors.on(:party_id)
    e = create_event(:venue_id => nil)
    assert e.errors.on(:venue_id)
    e = create_event(:happens_at => nil)
    assert e.errors.on(:happens_at)
    e = create_event(:search_date => nil)
    assert e.errors.on(:search_date)
    e = create_event(:hosted_by => "To")
    assert e.errors.on(:hosted_by)
    e = create_event(:synopsis => "11")
    assert e.errors.on(:synopsis)
  end
  
  protected
  def create_event(options = {})
    Event.create({ 
      :party_id => 1,
      :venue_id => 1,
      :happens_at => 5.days.from_now.to_s,
      :search_date => 5.days.from_now.to_s,
      :pictures_exist => false,
      :picture_count => 0, 
      :photographer_id => nil, 
      :hosted_by => 'Slim Pickens and Black Diamonds',
      :synopsis => nil,
      :flyer => true,
      :comments_allowed => true,
      :daylight_savings_time => false,
      :active => true }.merge(options))
  end
end
