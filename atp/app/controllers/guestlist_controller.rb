class GuestlistController < ApplicationController
	before_filter :login_required
  before_filter :verify, :except => [:new]
  
  def add
    if request.post?
      guestlist = Guestlist.blank params[:guestlist]
      guestlist.user_id = session[:user][:id]
      guestlist.event_id = @event.id
      g = params[:guestlist][:full_name_and_number_of_guests].split(/\+/)
      guestlist.full_name = g[0].to_s.strip
      guestlist.number_of_guests = g[1].to_i || 0
      if guestlist.save
        ajax_response 'Added to guestlist', true
      else
        ajax_response guestlist.errors.full_messages.join('. ')
      end
    end
  end
  
  def new
    @page_title = "Join Guestlist"
    render :layout => 'slim'
  end
  
  def list
    list = Guestlist.get_event_list(session[:user][:id], @event.id)
    if list
      ajax_response list.to_json, true
    else
      ajax_response "Access denied to guestlist."
    end
    return false
  end
  
  
  private  
  def verify
    begin
      @event = Event.find params[:event_id].to_i
    rescue ActiveRecord::RecordNotFound
      flash['bad'] = "Event ID Missing!"
      redirect_back_or_default home_url
      return
    end
  end
end