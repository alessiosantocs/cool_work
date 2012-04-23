require 'test_helper'

class DraftPersonnelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_personnels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_personnel" do
    assert_difference('DraftPersonnel.count') do
      post :create, :draft_personnel => { }
    end

    assert_redirected_to draft_personnel_path(assigns(:draft_personnel))
  end

  test "should show draft_personnel" do
    get :show, :id => draft_personnels(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => draft_personnels(:one).to_param
    assert_response :success
  end

  test "should update draft_personnel" do
    put :update, :id => draft_personnels(:one).to_param, :draft_personnel => { }
    assert_redirected_to draft_personnel_path(assigns(:draft_personnel))
  end

  test "should destroy draft_personnel" do
    assert_difference('DraftPersonnel.count', -1) do
      delete :destroy, :id => draft_personnels(:one).to_param
    end

    assert_redirected_to draft_personnels_path
  end
end
