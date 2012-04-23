require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @user = User.new
  end

  def test_destroy
    @user = users(:first)
    @user.destroy
    assert_raise(ActiveRecord::RecordNotFound) { User.find @user.id }
  end
  
  def test_should_create_user
    assert create_user.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 2, User.count
  end
  
  def test_should_authenticate_user
    assert_equal users(:first), User.authenticate('Joemocha', 'Ifeobu')
  end
  
  def test_should_not_authenticate_user
    assert_not_equal users(:first), User.authenticate('Joemocha@gmail.com', 'Ifeobu')
  end
  
  def test_should_reset_password
    pwd = 'new password'
    password = makesafe(pwd.gsub(/&#([0-9+])/, '-'))
    password = stripslashes(password)
    users(:first).update_attributes(:password => password, :password_confirmation => password)
    assert_equal users(:first).password_hash, User.authenticate('joemocha', pwd).password_hash
  end
  
  def test_should_not_rehash_password
    users(:first).update_attributes(:username => '3434343')
    assert_equal users(:first), User.authenticate('3434343', 'Ifeobu')
  end

  def test_should_require_username
    u = create_user(:username => nil)
    assert u.errors.on(:username)
  end
  
  def test_should_require_password_confirmation
    u = create_user(:password_confirmation => nil)
    assert_not_nil u.errors.on(:password_confirmation)
  end
  
  def test_show_duplicate_username
    u = create_user(:username => 'joemocha')
    assert u.errors.on(:username)
  end
  
  def test_show_duplicate_email
    u = create_user(:email => 'joemocha@gmail.com')
    assert u.errors.on(:email)
  end
  
  def test_should_not_login
    users(:second).update_attributes(:deleted => 1)
    assert_nil User.authenticate('jayneEyre', 'quire')
  end
  
  def test_these_passwords
    # first, let's try a few passwords that should fail
    u = create_user(:password => nil)
    assert u.errors.on(:password)
    u = create_user(:password => 'abc', :password_confirmation => 'abc')
    assert u.errors.on(:password)
    u = create_user(:password => '007', :password_confirmation => '007')
    assert u.errors.on(:password)
    u = create_user(:password => 'bond', :password_confirmation => 'bond')
    assert u.errors.on(:password)
    u = create_user(:password => '1234', :password_confirmation => '1234')
    assert u.errors.on(:password)
    u = create_user(:password => nil, :password_confirmation => nil)
    assert u.errors.on(:password)
    u = create_user(:password => '         ', :password_confirmation => '         ')
    assert u.errors.on(:password)
    u = create_user(:password => '&nbsp;&nbsp;', :password_confirmation => '&nbsp;&nbsp;')
    assert_nil u.errors.on(:password)
  end
  
  protected
  def create_user(options = {})
    User.create({ 
      :username => 'quagmire', 
      :email => 'quire@example.com', 
      :password => 'quire', 
      :sex => 'm',
      :country => 'us',
      :site_id => 1,
      :password_confirmation => 'quire'}.merge(options))
  end
end