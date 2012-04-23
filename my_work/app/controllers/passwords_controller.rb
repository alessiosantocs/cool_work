class PasswordsController < ApplicationController
  ssl_required :new, :create  
  layout 'zip'
  
  # Don't write passwords as plain text to the log files
  filter_parameter_logging :old_password, :password, :password_confirmation
  
  # GETs should be safe
  verify :method => :post, :only => [:create], :redirect_to => '/login'
  
  # POST /passwords
  # Forgot password
  def create
    respond_to do |format|
      
      if user = User.find_by_email(params[:email])
        @new_password = random_password
        user.password = user.password_confirmation = @new_password
        user.save_without_validation
        Notifier.deliver_new_password(user, @new_password)
        
        format.html {
          flash[:notice] = "We sent a new password to #{params[:email]}. Please check your email to login."
          redirect_to '/login'
        }
      else
        flash[:notice] =  "Sorry we can't find the account corresponding to that email address."
        format.html { render :action => "new" }
      end
    end
  end
  
  protected
  
  def random_password( len = 20 )
    chars = (("a".."z").to_a + ("1".."9").to_a )- %w(i o 0 1 l 0)
    newpass = Array.new(len, '').collect{chars[rand(chars.size)]}.join
    newpass
  end
  
end