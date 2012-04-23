class TagController < ApplicationController
  skip_before_filter :site_data
	before_filter :login_required
	before_filter :objs_required
	
  def new
    tags = params[:tags][:tag_list].to_s.strip.downcase
    if tags.length > 0
      @obj_rec.tag_with(tags, User.find(session[:user][:id]))
      render :partial => "layouts/shared/tag", :collection => @obj_rec.tag_list.split(/ /)
    else
      ajax_response "Tag is not added."
    end
  end
  
  private
  def login_required_for_ajax
    unless request.xhr?
      login_required
    else
      ajax_response 'You need to login or register.'
      return false
    end
  end
end