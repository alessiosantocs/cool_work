module LoginSystem
  protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    current_user != false
  end
  
  # Accesses the current user from the session.
  def current_user
    @current_user ||= (session[:user] && User.find(session[:user][:id])) || false
  end
  
  # Store the given user in the session.
  def current_user=(new_user)
    if new_user.nil? or new_user.is_a?(Symbol)
      session[:user] = false
    else
      session[:user] = {
        :id => new_user.id, 
        :username => new_user.username, 
        :email => new_user.email, 
        :country => new_user.country, 
        :postal_code => new_user.postal_code, 
        :roles => new_user.role_names
      }
      cookie_value = session[:user].except(:roles, :email).to_json.gsub(/\": /, "\":").gsub(/, /,",")
      cookies[:current_user] = {
        :value => cookie_value,
        :domain => ".#{SITE.url}"
      }
    end
  end

  def authorized?
    true
  end
  
  def login_required
    username, passwd = get_auth_data
    self.current_user ||= User.authenticate(username, passwd) || false if username && passwd
    logged_in? && authorized? ? true : access_denied
  end
  
  def promoter_required
    return true if promoter?
    flash[:bad] = "Access Denied"
    redirect_back_or_default account_manage_url
    return false 
  end
  
  def super_admin_required
    return true if super_admin?
    flash[:bad] = "Access Denied"
    store_location
    access_denied
    return false 
  end

  def regional_rep_required
    return true if super_admin? or admin? or regional_rep?
    flash[:bad] = "Access Denied"
    store_location
    access_denied
    return false 
  end
  
  ['Admin', 'Super Admin', 'Promoter', 'Photographer', 'Regional Rep'].each do |role|
    role_name = "#{role.gsub(' ','_').downcase}"
    define_method("#{role_name}?") do
      logged_in? and session[:user][:roles].include?("#{role}") ? true : false
    end
  end
  
  def changeable?(obj, id)
    return true if obj.user_id == id
    return true if super_admin? or admin?
    return false
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        redirect_to account_login_path
      end
      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Could't authenticate you", :status => '401 Unauthorized'
      end
      accepts.js do
        ajax_response 'You need to login or register.'
      end
    end
    false
  end  
  
  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end
  
  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
    session[:return_to] = nil
  end
  
  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  private
  @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
  # gets BASIC auth info
  def get_auth_data
    auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
    auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
    return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
  end
end