require File.dirname(__FILE__) + '/../test_helper'
require 'sms_controller'

# Re-raise errors caught by the controller.
class SmsController; def rescue_action(e) raise e end; end

class SmsControllerTest < Test::Unit::TestCase
  def setup
    @controller = SmsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
