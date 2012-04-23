require 'test_helper'

class DraftProductsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_product" do
    assert_difference('DraftProduct.count') do
      post :create, :draft_product => { }
    end

    assert_redirected_to draft_product_path(assigns(:draft_product))
  end

  test "should show draft_product" do
    get :show, :id => draft_products(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => draft_products(:one).to_param
    assert_response :success
  end

  test "should update draft_product" do
    put :update, :id => draft_products(:one).to_param, :draft_product => { }
    assert_redirected_to draft_product_path(assigns(:draft_product))
  end

  test "should destroy draft_product" do
    assert_difference('DraftProduct.count', -1) do
      delete :destroy, :id => draft_products(:one).to_param
    end

    assert_redirected_to draft_products_path
  end
end
