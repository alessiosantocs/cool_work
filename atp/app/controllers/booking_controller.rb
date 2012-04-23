class BookingController < ApplicationController
  def add
    if request.post?
      booking = Booking.blank(params[:booking])
      booking.user_id = session[:user][:id] if logged_in?
      if booking.save
        ajax_response 'Added to booking', true
      else
        ajax_response booking.errors.full_messages.join('. ')
      end
    end
  end
  
  def list
    unless params['party_id'].nil?
      list = Booking.get_party_list(session[:user][:id], params['event_id'].to_i)
      if list
        ajax_response list.to_json, true
      else
        ajax_response "Access denied to booking system."
      end
      return false
    end
    ajax_response "Party ID Missing!"
  end
end
