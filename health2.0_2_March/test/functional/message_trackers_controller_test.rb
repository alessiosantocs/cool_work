require 'test_helper'

class MessageTrackersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_trackers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_tracker" do
    assert_difference('MessageTracker.count') do
      post :create, :message_tracker => { }
    end

    assert_redirected_to message_tracker_path(assigns(:message_tracker))
  end

  test "should show message_tracker" do
    get :show, :id => message_trackers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => message_trackers(:one).to_param
    assert_response :success
  end

  test "should update message_tracker" do
    put :update, :id => message_trackers(:one).to_param, :message_tracker => { }
    assert_redirected_to message_tracker_path(assigns(:message_tracker))
  end

  test "should destroy message_tracker" do
    assert_difference('MessageTracker.count', -1) do
      delete :destroy, :id => message_trackers(:one).to_param
    end

    assert_redirected_to message_trackers_path
  end
end
