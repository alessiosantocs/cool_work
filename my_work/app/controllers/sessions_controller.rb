# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  ssl_required :new, :create  
  layout 'zip'
  
  # render new.rhtml
  def new
  end
  
  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = ""
      if self.current_user.employee?
        RecurringOrder.place_recurring_order()
        Customer.signup_invitee if self.current_user.admin?
        redirect_back_or_default("/admin")
      else
        redirect_back_or_default(dashboard_customer_path(self.current_user.account))
      end
    else
      flash[:error] = "Invalid login or password"
      @login = params[:login]
      @password = params[:password]
      render :action => 'new'
    end
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
  def auto_logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_to ('/automatic_logout')
  end
end
