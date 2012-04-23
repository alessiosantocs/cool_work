class FaveController < ApplicationController
  layout 'account'
  skip_before_filter :site_data, :except => [:list]
	before_filter :login_required
	before_filter :objs_required, :except => [:list]

  def initialize
    super
  end
  
  def add
    if SETTING["faveable"].include?(@obj_type)
      clear_old_faves
      Fave.create(:obj_type => @obj_type, :obj_id => @obj_id, :user_id => session[:user][:id])
      ajax_response "Fave Added.", true
    else
      ajax_response "No Fave"
    end
  end

  def drop
    clear_old_faves if SETTING["faveable"].include?(@obj_type)
    ajax_response "Fave Deleted.", true
  end

  def list
    @page_title << "My Favorites"
    @breadcrumb.drop_crumb("Manage Account", account_manage_url)
    @breadcrumb.drop_crumb("My Faves")
    type = params[:type].nil? ? "ImageSet" : params[:type].to_s
    @faves = Fave.find_by_user_and_type(session[:user][:id], type)
    respond_to do |wants|
      wants.html
      wants.js  { ajax_response "faves=#{@faves.to_json}; #{params[:callback]}();", true }
    end
  end

  private
  def clear_old_faves
    Fave.delete_all(["obj_type = ? AND obj_id = ? AND user_id = ?", @obj_type, @obj_id, session[:user][:id]])
  end
end
