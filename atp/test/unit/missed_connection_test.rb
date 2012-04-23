require File.dirname(__FILE__) + '/../test_helper'

class MissedConnectionTest < Test::Unit::TestCase
  fixtures :missed_connections
  
  def setup
    @missed_connection = MissedConnection.find 1
  end
  
  def test_should_create_missed_connection
    m = create_missed_connection()
    assert m.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, MissedConnection.count
  end

  def test_destroy
    @missed_connection.destroy
    assert_raise(ActiveRecord::RecordNotFound) { MissedConnection.find @missed_connection.id }
  end
  
  def test_validate
    assert_equal 1, @missed_connection.id
    @missed_connection.title = 'Alexina Vasquez Performs Live at Show\nAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@missed_connection.save
    assert_equal 1, @missed_connection.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of MissedConnection, @missed_connection
    assert_equal 1, @missed_connection.id
    assert_equal 1, @missed_connection.user_id
    assert_equal 55, @missed_connection.party_id
    assert_equal 1233, @missed_connection.venue_id
    assert_equal 'Nell\'s in the bathroom', @missed_connection.location
    assert_equal 'I don\'t know why I love you', @missed_connection.title
    assert_equal "Make me wanna scream", @missed_connection.story
    assert_equal "MF", @missed_connection.connection_type
    assert_equal '2006-02-12', @missed_connection.connection_date.strftime('%Y-%m-%d')
    assert_equal true, @missed_connection.published
  end
  
  def test_these_properties
    m = create_missed_connection(:user_id => nil)
    assert m.errors.on(:user_id)
    m = create_missed_connection(:connection_type => nil)
    assert m.errors.on(:connection_type)
    m = create_missed_connection(:connection_date => nil)
    assert m.errors.on(:connection_date)
  end
  
  protected
  def create_missed_connection(options = {})
    MissedConnection.create({ 
      :user_id => 1,
      :party_id => 1,
      :venue_id => 1,
      :connection_type => "FM",
      :connection_date => '2005-12-22',
      :location => "By the VIP staircase",
      :title => 'I am the soul that lives within',
      :story => "Validates that the specified attributes are not blank (as defined by Object#blank?). Happens by default on save.",
      :published => true}.merge(options))
  end
end
