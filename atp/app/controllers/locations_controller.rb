class LocationsController < ApplicationController
  session :off 
  def create
    data = params.only(:user_id, :party_id, :event_id, :user_id, :image_set_id)
    unless params[:user_id].to_i == 0
      Location.post(data)
      render :nothing => true
    end
  end
  
  def on_page
    
  end
end
