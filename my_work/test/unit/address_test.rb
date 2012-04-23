require File.dirname(__FILE__) + '/../test_helper'

class BuildingTest < ActiveSupport::TestCase
  fixtures :addresses, :locations
  
  def test_concords_with
    assert addresses(:b1stallman).concords_with(locations(:l10))
    assert addresses(:b1sussman).concords_with(locations(:l9))
    #assert addresses(:b1stallman).concords_with(locations(:l10)) # for some reason this doesn't work... address.target may not work with fixtures...
  end
  
  
end