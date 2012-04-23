require File.dirname(__FILE__) + '/../test_helper'
require 'tool_controller'

# Re-raise errors caught by the controller.
class ToolController; def rescue_action(e) raise e end; end

class ToolControllerTest < Test::Unit::TestCase
  def setup
    @controller = ToolController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
