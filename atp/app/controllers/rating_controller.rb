class RatingController < ApplicationController
  skip_before_filter :site_data
	before_filter :login_required
	before_filter :objs_required

  def rate
    rating_range = 0..5
    rating = params[:rating].to_i
    if SETTING["rateable"].include?(@obj_type) and rating_range === rating
      Rating.delete_all(["rateable_type = ? AND rateable_id = ? AND user_id = ?", @obj_type, @obj_id, session[:user][:id]])
      @obj_rec.add_rating( Rating.new(:rating => rating, :user_id => session[:user][:id]) )
      render :partial => "layouts/shared/rating", :locals => { :asset => @obj_rec }
    else
      ajax_response "Not Rateable"
    end
  end

end