require File.dirname(__FILE__) + '/../test_helper'

class ConfessionTest < Test::Unit::TestCase
  fixtures :confessions
  
  def setup
    @confession = Confession.find 1
  end
  
  def test_should_create_confession
    c = create_confession()
    assert c.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 2, Confession.count
  end

  def test_destroy
    @confession.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Confession.find @confession.id }
  end
  
  def test_validate
    assert_equal 1, @confession.id
    @confession.title = 'Alexina Vasquez Performs Live at Show\nAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@confession.save
    assert_equal 1, @confession.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Confession, @confession
    assert_equal 1, @confession.id
    assert_equal 33, @confession.user_id
    assert_equal 'Nell\'s in the bathroom', @confession.location
    assert_equal 'I don\'t know why I love you', @confession.title
    assert_equal "Make me wanna scream", @confession.story
    assert_equal true, @confession.published
  end
  
  def test_these_properties
    c = create_confession(:user_id => nil)
    assert c.errors.on(:user_id)
    c = create_confession(:location => nil)
    assert c.errors.on(:location)
    c = create_confession(:title => nil)
    assert c.errors.on(:title)
    c = create_confession(:story => nil)
    assert c.errors.on(:story)
  end
  
  protected
  def create_confession(options = {})
    Confession.create({ 
      :user_id => 1,
      :name => "Aby inda Mix",
      :location => "Train station in Bombay, India",
      :title => 'I am the soul that lives within',
      :story => "Validates that the specified attributes are not blank (as defined by Object#blank?). Happens by default on save.",
      :published => true}.merge(options))
  end
end
