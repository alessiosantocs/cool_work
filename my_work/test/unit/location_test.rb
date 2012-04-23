require File.dirname(__FILE__) + '/../test_helper'

class LocationObserverTest < Test::Unit::TestCase
  fixtures :locations

  def test_get_schedule
    assert locations(:l1).get_schedule(Date.today())
  end
  
  def test_concords_with
    assert locations(:l9).concords_with(locations(:l10))
  end
end