require File.dirname(__FILE__) + '/../test_helper'

class NotificationTemplatesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:notification_templates)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_notification_template
    assert_difference('NotificationTemplate.count') do
      post :create, :notification_template => { }
    end

    assert_redirected_to notification_template_path(assigns(:notification_template))
  end

  def test_should_show_notification_template
    get :show, :id => notification_templates(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => notification_templates(:one).id
    assert_response :success
  end

  def test_should_update_notification_template
    put :update, :id => notification_templates(:one).id, :notification_template => { }
    assert_redirected_to notification_template_path(assigns(:notification_template))
  end

  def test_should_destroy_notification_template
    assert_difference('NotificationTemplate.count', -1) do
      delete :destroy, :id => notification_templates(:one).id
    end

    assert_redirected_to notification_templates_path
  end
end
