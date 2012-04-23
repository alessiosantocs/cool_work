require 'test_helper'

class DraftCompanyCategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_company_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_company_category" do
    assert_difference('DraftCompanyCategory.count') do
      post :create, :draft_company_category => { }
    end

    assert_redirected_to draft_company_category_path(assigns(:draft_company_category))
  end

  test "should show draft_company_category" do
    get :show, :id => draft_company_categories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => draft_company_categories(:one).to_param
    assert_response :success
  end

  test "should update draft_company_category" do
    put :update, :id => draft_company_categories(:one).to_param, :draft_company_category => { }
    assert_redirected_to draft_company_category_path(assigns(:draft_company_category))
  end

  test "should destroy draft_company_category" do
    assert_difference('DraftCompanyCategory.count', -1) do
      delete :destroy, :id => draft_company_categories(:one).to_param
    end

    assert_redirected_to draft_company_categories_path
  end
end
