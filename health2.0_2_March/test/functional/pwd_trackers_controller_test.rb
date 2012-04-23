require 'test_helper'

class PwdTrackersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pwd_trackers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pwd_tracker" do
    assert_difference('PwdTracker.count') do
      post :create, :pwd_tracker => { }
    end

    assert_redirected_to pwd_tracker_path(assigns(:pwd_tracker))
  end

  test "should show pwd_tracker" do
    get :show, :id => pwd_trackers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pwd_trackers(:one).to_param
    assert_response :success
  end

  test "should update pwd_tracker" do
    put :update, :id => pwd_trackers(:one).to_param, :pwd_tracker => { }
    assert_redirected_to pwd_tracker_path(assigns(:pwd_tracker))
  end

  test "should destroy pwd_tracker" do
    assert_difference('PwdTracker.count', -1) do
      delete :destroy, :id => pwd_trackers(:one).to_param
    end

    assert_redirected_to pwd_trackers_path
  end
end
