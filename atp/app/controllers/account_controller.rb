class AccountController < ApplicationController
  include Countries
  before_filter :login_required, :except => [:login, :lost_password, :logout, :create, :validate, :reset_password, :welcome]
  before_filter :only_non_users, :only => [:create, :lost_password, :validate, :reset_password, :welcome]

  def initialize
    super
  end

  def create
    @countries = all_in_array
    @breadcrumb.drop_crumb("Sign Up")
    @page_title << " Join and see what you've been missing."
    case request.method
      when :post
        @user = User.blank(params[:user])
        @user.username = params[:user][:username].downcase
        @user.email = params[:user][:email].downcase
        @user.location = params[:user][:city].to_s.strip + ", " + params[:user][:state].to_s.strip
        @user.site_id = SITE_ID
        if @user.save
          add_roles_to_user(@user, params[:role])
          flash['good'] = "Congrats. Welcome to #{SITE.full_name}"
          Notifier::deliver_signup_thanks(@user, SITE)
          redirect_to :action => 'welcome'
          return false
        end
      when :get
        @user = User.blank
    end
    
    render :layout => "editor"
  end

  def login
    @breadcrumb.drop_crumb("Login")
    @page_title << "Login"
    if request.post?
      self.current_user = User.authenticate_using_params(params)
      if logged_in?
        flash[:good] = "Logged in successfully"
        redirect_back_or_default('/')
      else
        flash[:bad] = "Login failed"
      end
    end
  end
  
  def update
    @countries = all_in_array
    @user = User.find(@current_user.id)
    if request.method == :post
      if (promoter? or photographer?) and !params[:user][:company_name].nil?
        if params[:user][:company_name].strip.length < 3
          flash[:bad] = "Company name should be longer than three characters."
          redirect_to :back
          return
        end
      end
      if @user.update_attributes(params[:user])
        add_roles_to_user(@user, params[:role])
        self.current_user = @user
        flash[:good] = "Update Successful"
        redirect_to account_manage_url
        return
      else
        flash[:bad] = "Update Failed"
      end
    end
    @breadcrumb.drop_crumb("Manage Account", account_manage_url)
    case params[:sub_action]
      when "roles"
        @breadcrumb.drop_crumb("Update Roles")
        @page_title << "Update Roles"
      when "miscellaneous"
        @breadcrumb.drop_crumb("Update Additional Information")
        @page_title << "Update Additional Information"
      when "mail_preference"
        @breadcrumb.drop_crumb("Update Mail Preference")
        @page_title << "Update Mail Preference"
      when "password"
        @breadcrumb.drop_crumb("Update Password")
        @page_title << "Update Password"
      when "email_address"
        @breadcrumb.drop_crumb("Update Email Address")
        @page_title << "Update Email Address"
      when "location"
        @breadcrumb.drop_crumb("Update Location and Time Zone")
        @page_title << "Update Location and Time Zone"
      else
        flash[:bad] = "Choose what you want to update."
        redirect_to account_manage_url
        return
    end
    render :action => 'update_account'
  end

  def manage
    @breadcrumb.drop_crumb("Manage Account")
    @page_title << " Manage Account"
    @recent_order = Order.history_by_user(@current_user.id, 0, 1)
  end

  def lost_password
    @breadcrumb.drop_crumb("Lost Password")
    @page_title << "Lost Password"
    case request.method
      when :post
        if @user = User.find_by_email(params[:user][:email].to_s)
          Notifier::deliver_lost_password(@user, SITE)
          ajax_response "Account found. Email sent.", true
        else
          ajax_response "Account not found. Please check email address."
        end
        return false
      when :get
    end
  end

  def reset_password
    @breadcrumb.drop_crumb("Reset Password")
    @page_title << "Reset Password"
    if @user = User.find_by_id(params[:id].to_i)
      unless @user.member_login_key.reverse == params[:key].to_s
        flash[:bad] = "Invalid user/key combo"
        redirect_to account_login_url
        return false
      end
    end
  
    case request.method
      when :post
        if @user.update_attributes(params[:user])
          verify_login(@user)
          flash[:good] = "Account updated"
        else
          flash[:bad] = "Account not updated."
        end
      when :get
    end
  end

  def logout
    session[:user] = false if logged_in?
    [:current_user, :upload_id].each{ |c| clear_cookies(c) }
    flash[:good] = "You have logged out."
    redirect_to home_url
  end

  def validate
    name = params[:name].to_s.strip
    value = params[:value].to_s.strip
    case name
      when "user_email"
        if User.find_by_email(value)
          ajax_response "new Message('#{value} is used by someone else. Please pick another email address.'); $('#{name}').focus();"
        else
          ajax_response "new Message('The email address is available', 'good');", true
        end
      when "user_username"
        if User.find_by_username(value)
          ajax_response "new Message('#{value} is used by someone else. Please pick another name.'); $('#{name}').focus();"
        else
          ajax_response "new Message('The username is available', 'good');", true
        end
      else
        ajax_response "new Message('We got a problem. Let Sam know what is wrong.');"
    end
  end

  def autocomplete
    error_exists = false
    error_text = ""
    if params[:user][:username].nil?
      error_text = "No Query variable"
      error_exists = true
    end
    if params[:relation].nil?
      error_text = "No Relation variable"
      error_exists = true
    end
    unless error_exists
      q = params[:user][:username].downcase.strip
      relation = params[:relation].strip
    else
      ajax_response error_text
      return
    end
    
    query_hash = { :conditions => ["username"], :show => ["username", "location", "mobile"], :order => "username" }
    query_condition = query_hash[:conditions].collect{|field| "LOWER(#{field}) LIKE \"%#{q}%\" " }.join(" OR ")
    find_options = {
      :select => "id, username",
      :conditions => query_condition,
      :order => query_hash[:order],
      :limit => 25 }
    @items = User.find(:all, find_options)
    query_hash[:show] << "id" #added id to be passed through callback function
    ajax_response "<%= auto_complete_result_with_callback @items, " + query_hash[:show].to_json + ", '#{relation}' %>", true
  end

  private
  def only_non_users
    if logged_in?
      redirect_back_or_default home_url
      return
    end
  end

  def verify_login(user)
    respond_to do |format|
      format.html do
        if user and user.deleted != true
          self.current_user = user
          flash[:good] = "Login successful"
          redirect_back_or_default params[:url] || '/'
        else
          user = User.new
          user.password = ""
          flash[:bad] = "Login failed"
          redirect_back_or_default account_login_path
          return
        end
      end
      format.js { (user and user.deleted != true) ? ajax_response("", true) : ajax_response("") }
    end
  end
  
  def add_roles_to_user(user, roles={})
    return if roles.nil?
    restricted_roles = SETTING['restricted_roles'] #["Super Admin", "Admin", "Moderator"]
  
    # filter out unselected roles and banned roles
    valid_roles = roles.partition{|k,v| v.to_i == 1 and !restricted_roles.include?(k) }.first
  
    return if valid_roles.nil?
    if logged_in?
      valid_roles = valid_roles.partition{|k,v| !session[:user][:roles].include?(k.capitalize)  }.first
    end
  
    return if valid_roles.nil?
    valid_roles.each do |k,v|
      user.roles << Role.find(:first, :conditions => ["name=?", k])
    end
  end
end
