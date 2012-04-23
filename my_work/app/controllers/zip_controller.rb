class ZipController < ApplicationController
  
  def index
  end
  
  def check
    if Building.supported_zips.include?(params[:zip].to_s)
      redirect_to signup_url + '?zip=' + params[:zip].to_s 
      session[:zip_approved] = 'true'
      session[:zip] = params[:zip]
    else
      redirect_to '/zip/deny' + '?zip=' + params[:zip].to_s
    end
  end
  
  def deny
  end
  
  def complete
    if request.post? && !params[:zip].blank? && !params[:name].blank? && !params[:email].blank?
      message = "Zip request from " + params[:name] + ", Zip: " + params[:zip]
      email = params[:email]
      Notifier.deliver_contact_message(email, "service@myfreshshirt.com", message)
      redirect_to '/how_it_works'
    else
      flash[:error] = 'Please fill in the whole form'
      redirect_to '/zip/deny?'+'zip='+params[:zip]+'&name='+params[:name]+'&email='+params[:email]
    end
  end
  
end
