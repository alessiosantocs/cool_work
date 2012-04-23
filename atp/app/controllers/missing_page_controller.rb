class MissingPageController < ApplicationController
  session :off
  caches_page
  
  def old_event_images
    redirect_to image_set_url(:obj_id => params[:obj_id], :obj_type=> 'event')
  end
  
  def handle_unrecog
   #do something here, the path info is in the params value
   #render :inline => "Resource Not Available", :status => "404 Page Not Found"
   render :controller => 'page', :action => "missing", :layout => nil
  end
  
  def producer
    if !params[:user_id].nil?
      user = User.find(params[:user_id].to_i)
    elsif !params[:username].nil?
      user = User.find_by_username(params[:username].to_s)
    end
    unless user.nil?
      redirect_to people_url(:username => user.username)
    else
      method_missing("410 Gone")
    end
  end
  
  def login
    redirect_to account_login_url
  end
  
  def signup
    redirect_to account_create_url
  end
  
  def buy
    method_missing("410 Gone")
  end
  
  def image
    method_missing("410 Gone")
  end
  
  def old
   method_missing("410 Gone")
  end
  
  def scanner
   method_missing("410 Gone")
  end
  
  def news
    redirect_to "http://blog.alltheparites.com/"
  end
  
  def venue
    method_missing("410 Gone")
  end
  
  private
  def method_missing(status="404 Page Not Found")
    render :inline => "Resource Not Available", :status => status
  end
end
