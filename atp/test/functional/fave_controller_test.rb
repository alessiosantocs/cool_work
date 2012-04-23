require File.dirname(__FILE__) + '/../test_helper'
require 'fave_controller'

# Re-raise errors caught by the controller.
class FaveController; def rescue_action(e) raise e end; end

class FaveControllerTest < Test::Unit::TestCase
  def setup
    @controller = FaveController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
