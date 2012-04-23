require File.dirname(__FILE__) + '/../test_helper'

class ItemTypeTest < ActiveSupport::TestCase
  def test_available_services
    assert ItemType.find_by_name("shoe").available_services == [Service.find_by_name("shoes")]
    assert ItemType.find_by_name("woven shirt").available_services.include?(Service.find_by_name("dry cleaning"))
    assert ItemType.find_by_name("woven shirt").available_services.include?(Service.find_by_name("launder"))
  end
end
