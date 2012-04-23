require 'test_helper'

class DraftInvestmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_investments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_investment" do
    assert_difference('DraftInvestment.count') do
      post :create, :draft_investment => { }
    end

    assert_redirected_to draft_investment_path(assigns(:draft_investment))
  end

  test "should show draft_investment" do
    get :show, :id => draft_investments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => draft_investments(:one).to_param
    assert_response :success
  end

  test "should update draft_investment" do
    put :update, :id => draft_investments(:one).to_param, :draft_investment => { }
    assert_redirected_to draft_investment_path(assigns(:draft_investment))
  end

  test "should destroy draft_investment" do
    assert_difference('DraftInvestment.count', -1) do
      delete :destroy, :id => draft_investments(:one).to_param
    end

    assert_redirected_to draft_investments_path
  end
end
