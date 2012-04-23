require File.dirname(__FILE__) + '/../test_helper'

class ServiceTest < ActiveSupport::TestCase
  fixtures :services, :prices, :item_types
  
  def test_applicable_item_types
    assert Service.find_by_name("wash and fold").applicable_item_types == [ItemType.find_by_name("assorted")]
    assert Service.find_by_name("dry cleaning").applicable_item_types.include?(ItemType.find_by_name("pants"))
    assert Service.find_by_name("dry cleaning").applicable_item_types.include?(ItemType.find_by_name("jacket"))
  end
end
