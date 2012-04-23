require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  def setup
    @controller = UserController.new
    request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    # for testing action mailer
    # @emails = ActionMailer::Base.deliveries 
    # @emails.clear
    @user_hash = { 
      :username => 'quire', 
      :email => 'quire@example.com', 
      :mobile => "212-740-1212",
      :password => 'quire', 
      :password_confirmation => 'quire' }
  end
  
  def test_add_success
    old_count = User.count
    create_user
    assert_kind_of User, assigns(:user)
    assert_equal old_count + 1, User.count
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'user'
    assert_equal 40, assigns(:user).crypted_password.length
  end
  
  def test_add_no_email_address
    old_count = User.count
    create_user({:email => nil })
    assert_kind_of User, assigns(:user)
    assert_equal old_count, User.count
    assert_template 'errors'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error'
    assert_equal true, assigns(:user).crypted_password.nil?
  end
  
  def test_add_bad_email_address
    old_count = User.count
    create_user({:email => "secondchance@scene" })
    assert_kind_of User, assigns(:user)
    assert_equal old_count, User.count
    assert_template 'errors'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error', :attributes => { :id => 10 }
    assert assigns(:user).errors.on(:email)
  end
  
  def test_update_success
    old_count = User.count
    update_user({:email => "Akuja@aol.com"})
    assert_equal old_count, User.count
    assert_kind_of User, assigns(:user)
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'user'
    assigns(:user).reload
    assert_equal "Akuja@aol.com", assigns(:user).email
    assert_not_equal 2, assigns(:user).id
  end
  
  def test_update_failure_bad_email
    update_user({:email => "ne"}) #bad email address
    assert_kind_of User, assigns(:user)
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error'
    assert assigns(:user).errors.on(:email)
  end
  
  def test_update_failure_bad_username
    update_user({:username => "ne"}) #bad username
    assert_kind_of User, assigns(:user)
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'user'
  end
  
  def test_update_failure_username_no_change
    update_user({:username => "nefetiri"}) #bad username
    assert_kind_of User, assigns(:user)
    assert_equal 'application/xml', @response.content_type
    assert_not_equal "nefetiri", assigns(:user).username
    assert_tag :tag => 'user'
  end
  
  def test_update_failure_bad_id
    update_user({:id => "2sss333"}) #bad email address
    assert_kind_of User, assigns(:user)
    assert_equal 'application/xml', @response.content_type
    assert_equal 1, assigns(:user).id
  end
  
  def test_return_bad_email_address_error
    old_count = User.count
    create_user({:email => nil })
    assert assigns(:user).errors.on(:email)
  end
  
  def test_show_user
    get :show, :id => 1
    assert_kind_of User, assigns(:user)
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'user'
    assert_equal 'secondchance@scene.cc', assigns(:user).email
  end
  
  def test_show_user_does_not_exist
    get :show, :id => 52134123412412341234
    assert_template 'errors'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error'
    assert_equal true, assigns(:user).nil?
  end
  
  def test_show_user_does_not_exist_2
    get :show, :id => 'adfasdfsdfasd'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error'
    assert_equal true, assigns(:user).nil?
  end
  
  def test_login_successful
    get :login, :password => 'Ifeobu', :username=>'Joemocha'
    assert_kind_of User, assigns(:user)
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => "user", :child => { :tag => 'auth', :content => "dee1c200d68710b74bf212077e27dedee1cdc0e6" }
  end
  
  def test_login_failure_bad_username
    get :login, :password => 'Ifeobu', :username=>'Joem'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error', :attributes => { :id => 10 }
  end

  def test_login_failure_bad_password
    get :login, :password => 'Ife', :username=>'Joemocha'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error', :attributes => { :id => 10 }
  end

  def test_login_failure_not_verified
    get :login, :password => 'ghettofab', :username=>'jamiroquai'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => 'error', :attributes => { :id => 11 }
  end

  def test_lost_password_success
    get :lost_password, :email => 'secondchance@scene.cc'
    assert_equal 'application/xml', @response.content_type
    assert_tag :tag => "user", :child => { :tag => 'emailkey', :content => assigns(:user).emailkey }
  end
  
  protected
  def create_user(options = {})
    post :add, :user => @user_hash.merge(options)
  end
  
  def update_user(options = {})
    post :update, :id=> 1, :key => "3f5e31ac1882d50224e13c72c1756f44de813e7a", 
      :user => {
        :username => 'jamiroquai', 
        :email => 'secondchance@scene.cc',
        :mobile => "516-555-9999",
        :password => 'ghettofab', 
        :password_confirmation => 'ghettofab' }.merge(options)
  end
end