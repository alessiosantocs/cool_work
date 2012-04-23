require File.dirname(__FILE__) + '/../test_helper'

class PictureTest < Test::Unit::TestCase
  fixtures :pictures
  
  def setup
    @picture = Picture.find 1
  end
  
  def test_should_create_picture
    p = create_picture()
    assert p.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Picture.count
  end

  def test_destroy
    @picture.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Picture.find @picture.id }
  end
  
  def test_validate
    assert_equal 1, @picture.id
    @picture.caption = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@picture.save
    assert_equal 1, @picture.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Picture, @picture
    assert_equal 1, @picture.id
    assert_equal 1, @picture.event_id
    assert_equal "00", @picture.file_name
    assert_equal "Run-DMC in Tavern, Southampton", @picture.caption
    assert_equal 1, @picture.position
    assert_equal false, @picture.comments_allowed
  end
  
  def test_these_properties
    p = create_picture(:event_id => nil)
    assert p.errors.on(:event_id)
    p = create_picture(:file_name => 9)
    assert p.errors.on(:file_name)
    p = create_picture(:file_name => '9')
    assert p.errors.on(:file_name)
    p = create_picture(:caption => 'AN')
    assert p.errors.on(:caption)
  end
  
  protected
  def create_picture(options = {})
    Picture.create({ 
      :event_id => 1,
      :file_name => "05",
      :caption => 'Slim Pickens and Black Diamonds',
      :position => 4,
      :comments_allowed => true}.merge(options))
  end
end
