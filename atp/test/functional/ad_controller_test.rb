require File.dirname(__FILE__) + '/../test_helper'
require 'ad_controller'

# Re-raise errors caught by the controller.
class AdController; def rescue_action(e) raise e end; end

class AdControllerTest < Test::Unit::TestCase
  def setup
    @controller = AdController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
