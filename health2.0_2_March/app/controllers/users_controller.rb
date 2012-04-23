class UsersController < ApplicationController
  require 'uuidtools' 
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    cont = false 
	if (params[:user][:login].index("@") != nil and params[:user][:login].size > 0)
		logger.info("@ was detected")
		if @user.save
			cont = true
			flash[:notice] = "Account registered!"
			
			message = "Welcome to Health2.0. Welcome to our community. \n"
			message += "Please keep the following registration information for your records. \n"
			message += "username: " + params[:user][:login] + "\n"
			message += "password: " + params[:user][:password] + "\n"
			CustomMessage.deliver_send_CustomMessage(@user.login,"noreply@health2advisors.com","Welcome to Health 2.0",message)
			redirect_back_or_default account_url
		else
			flash[:notice] = "Please make sure that you have entered a valid email and that your passwords match."
		end 
	else 
		flash[:notice] = "Please make sure that you have entered a valid email address."
    end 
    if !cont
		render :action => :new
    end 
  end
  
  def forgot_password
	uuid = UUIDTools::UUID.timestamp_create
	
	if params[:email] 
		user = User.find(:all, :conditions => ["login = ?",params[:email]])
		@user = user[0] 
		urlKey = uuid.to_s
		urlLink = "http://www.health2advisors.com/users/edit?key="+urlKey
	
		message = "We recently recieved a request from you that you regarding your password. \n"
		message += "Please click the following URL to reset your password: \n"
		message += urlLink + "\n"
	
		CustomMessage.deliver_send_CustomMessage(@user.login,"noreply@health2advisors.com","forgotten password",message)
	
		@pwdt = PwdTracker.new({"email" => @user.login, "urlKey" => urlKey})
		flash[:notice] = "An email has been sent to the address indicated. Please follow the instructions in the email to reset your password."
		@pwdt.save
	else
		flash[:notice] = ""
	end
	
	respond_to do |format|
		format.html
	end 
	
  end 
  


  
  
  def show
    @count_company =Company.count(:conditions => ["enabled = ?",1])
    @count=Company.count
    @user = @current_user
    @subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
    @admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
	@a_str = "false"
    if @admin.to_s != "" 
       @a_str = params[:a_str]
       @subscribed = true 
    end 
  end

  def edit
    urlKey = params[:key]
	
	
		if current_user
			@sChanging = false 
			@user = @current_user
		
	else
			@sChanging = true 
			urlKey = params[:key]
			logger.info(urlKey)
			pwdTracker = PwdTracker.find(:all, :conditions => ["urlKey = ?", urlKey])
			logger.info(pwdTracker[0]["email"])
			user = User.find(:all, :conditions => ["login = ?", pwdTracker[0]["email"].downcase])
			@user = User.find(user[0]["id"])
			@user_session = UserSession.new({"login" => @user["login"],"password" => @user["crypted_password"]})
			logger.info(@user_session.save)
			@current_user = @user
		end
	 
  end
  
  def update
    @sChanging = false 
	if current_user
		@user = @current_user # makes our views "cleaner" and more consistent
	end
	
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
	  message = "You have successfully updated your password! Please note your new login credentials:\n"
	  message += "username: " +@user.login+"\n"
	  message += "password: " +params[:user][:password]+"\n"
	
	  CustomMessage.deliver_send_CustomMessage(@user.login,"noreply@health2advisors.com","password updated",message)
      
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
