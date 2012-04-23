require File.dirname(__FILE__) + '/../test_helper'
require 'booking_controller'

# Re-raise errors caught by the controller.
class BookingController; def rescue_action(e) raise e end; end

class BookingControllerTest < Test::Unit::TestCase
  def setup
    @controller = BookingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
