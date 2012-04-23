require File.dirname(__FILE__) + '/../test_helper'

class FaveTest < Test::Unit::TestCase
  fixtures :faves
  
  def setup
    @fave = Fave.find 1
  end
  
  def test_should_create_fave
    t = create_fave()
    assert t.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Fave.count
  end

  def test_destroy
    @fave.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Fave.find @fave.id }
  end
  
  def test_validate
    assert_equal 1, @fave.id
    @fave.obj_type = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@fave.save
    assert_equal 1, @fave.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Fave, @fave
    assert_equal 1, @fave.id
    assert_equal 56, @fave.obj_id
    assert_equal "Venue", @fave.obj_type
    assert_equal 250, @fave.user_id
  end
  
  def test_these_properties
    t = create_fave(:obj_id => nil)
    assert t.errors.on(:obj_id)
    t = create_fave(:obj_type => nil)
    assert t.errors.on(:obj_type)
    t = create_fave(:user_id => nil)
    assert t.errors.on(:user_id)
  end
  
  protected
  def create_fave(options = {})
    Fave.create({ 
      :obj_id => 1200,
      :obj_type => "Picture",
      :user_id => 545}.merge(options))
  end
end
