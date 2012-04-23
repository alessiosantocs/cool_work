require 'test_helper'

class DraftCompaniesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_company" do
    assert_difference('DraftCompany.count') do
      post :create, :draft_company => { }
    end

    assert_redirected_to draft_company_path(assigns(:draft_company))
  end

  test "should show draft_company" do
    get :show, :id => draft_companies(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => draft_companies(:one).to_param
    assert_response :success
  end

  test "should update draft_company" do
    put :update, :id => draft_companies(:one).to_param, :draft_company => { }
    assert_redirected_to draft_company_path(assigns(:draft_company))
  end

  test "should destroy draft_company" do
    assert_difference('DraftCompany.count', -1) do
      delete :destroy, :id => draft_companies(:one).to_param
    end

    assert_redirected_to draft_companies_path
  end
end
