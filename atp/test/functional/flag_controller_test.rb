require File.dirname(__FILE__) + '/../test_helper'
require 'flag_controller'

# Re-raise errors caught by the controller.
class FlagController; def rescue_action(e) raise e end; end

class FlagControllerTest < Test::Unit::TestCase
  def setup
    @controller = FlagController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
