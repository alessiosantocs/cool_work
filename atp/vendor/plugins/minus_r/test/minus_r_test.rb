require 'test/unit'

class MockController
  
  self.base_path = File.dirname(__FILE__) + '/fixtures/'
  
  def test
  end
  
end

class MinusRTest < Test::Unit::TestCase
  
  def test_should_allow_real_proper_javascript_in_rjs
    flunk
  end
  
  def test_rjs_should_have_text_javascript_header
    flunk
  end
  
  def test_should_have_js_helper_that_to_jsons_argument
    flunk
  end
  
end
