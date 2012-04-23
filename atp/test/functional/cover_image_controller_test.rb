require File.dirname(__FILE__) + '/../test_helper'
require 'cover_image_controller'

# Re-raise errors caught by the controller.
class CoverImageController; def rescue_action(e) raise e end; end

class CoverImageControllerTest < Test::Unit::TestCase
  def setup
    @controller = CoverImageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
