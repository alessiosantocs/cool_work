require 'test_helper'

class DraftReviewsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_reviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_review" do
    assert_difference('DraftReview.count') do
      post :create, :draft_review => { }
    end

    assert_redirected_to draft_review_path(assigns(:draft_review))
  end

  test "should show draft_review" do
    get :show, :id => draft_reviews(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => draft_reviews(:one).to_param
    assert_response :success
  end

  test "should update draft_review" do
    put :update, :id => draft_reviews(:one).to_param, :draft_review => { }
    assert_redirected_to draft_review_path(assigns(:draft_review))
  end

  test "should destroy draft_review" do
    assert_difference('DraftReview.count', -1) do
      delete :destroy, :id => draft_reviews(:one).to_param
    end

    assert_redirected_to draft_reviews_path
  end
end
