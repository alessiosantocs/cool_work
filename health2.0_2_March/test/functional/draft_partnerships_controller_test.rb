require 'test_helper'

class DraftPartnershipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_partnerships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_partnership" do
    assert_difference('DraftPartnership.count') do
      post :create, :draft_partnership => { }
    end

    assert_redirected_to draft_partnership_path(assigns(:draft_partnership))
  end

  test "should show draft_partnership" do
    get :show, :id => draft_partnerships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => draft_partnerships(:one).to_param
    assert_response :success
  end

  test "should update draft_partnership" do
    put :update, :id => draft_partnerships(:one).to_param, :draft_partnership => { }
    assert_redirected_to draft_partnership_path(assigns(:draft_partnership))
  end

  test "should destroy draft_partnership" do
    assert_difference('DraftPartnership.count', -1) do
      delete :destroy, :id => draft_partnerships(:one).to_param
    end

    assert_redirected_to draft_partnerships_path
  end
end
