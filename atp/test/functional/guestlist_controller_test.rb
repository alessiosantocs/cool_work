require File.dirname(__FILE__) + '/../test_helper'
require 'guestlist_controller'

# Re-raise errors caught by the controller.
class GuestlistController; def rescue_action(e) raise e end; end

class GuestlistControllerTest < Test::Unit::TestCase
  def setup
    @controller = GuestlistController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
