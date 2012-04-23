require 'test_helper'

class EmailTrackersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:email_trackers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create email_tracker" do
    assert_difference('EmailTracker.count') do
      post :create, :email_tracker => { }
    end

    assert_redirected_to email_tracker_path(assigns(:email_tracker))
  end

  test "should show email_tracker" do
    get :show, :id => email_trackers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => email_trackers(:one).to_param
    assert_response :success
  end

  test "should update email_tracker" do
    put :update, :id => email_trackers(:one).to_param, :email_tracker => { }
    assert_redirected_to email_tracker_path(assigns(:email_tracker))
  end

  test "should destroy email_tracker" do
    assert_difference('EmailTracker.count', -1) do
      delete :destroy, :id => email_trackers(:one).to_param
    end

    assert_redirected_to email_trackers_path
  end
end
