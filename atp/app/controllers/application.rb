class ApplicationController < ActionController::Base
  session :session_key => '_session_id'
  include LoginSystem
  include Breadcrumb rescue nil
  include HoptoadNotifier::Catcher
  helper CarouselHelper
  
  filter_parameter_logging ["password", "password_hash", "member_login_key", "cvv2"]
  helper_method :local_request?, :logged_in?, :promoter?, :photographer?, :get_city_short_name
  before_filter :disable_link_prefetching, :site_data
  
  def initialize
    @page_title = ""
		@breadcrumb = Breadcrumb.new rescue nil
    add2ads "728x90_ros"
  end
  
  def add2ads(ad)
    @google_ads ||= []
    @google_ads << ad
  end
  
  def reset_ads
    @google_ads =[]
  end
  
  protected
  def local_request?
    ["127.0.0.1", "69.86.116.48", "67.82.248.92"].include?(request.remote_ip)
  end
  
  def site_data
    region_name = request.subdomains.first.to_s.slice(0..2).to_sym rescue :www
    unless region_name  =~ /:www/
      @region_id = REGION_HASH[region_name]
      unless @region_id.nil?
        @region_name = region_name.to_s
        @city_ids = CITY_ID_HASH[region_name]
        @region = Region.find @region_id
  		end
		end
		check_bg_task
  end
  
	def objs_required
    begin
      @obj_type = params['obj_type'].to_s.camelize
      @obj_id = params['obj_id'].to_i
      @obj_rec = @obj_type.constantize.find @obj_id
    rescue NameError
      ajax_response "Variables Missing."
      return
    rescue ActiveRecord::RecordNotFound
      ajax_response "#{@obj_type} not found."
      return
    end
	end
	
  def get_city_short_name(id)
    res = CITY_ID_HASH.detect{|k,v| v.to_s == id.to_s }
    res.nil? ? nil : res[0].to_s
  end
  
	private
	def disable_link_prefetching
     if request.env["HTTP_X_MOZ"] == "prefetch" 
       logger.debug "prefetch detected: sending 403 Forbidden" 
       render :status => 403
       return false
     end
  end
  
  def check_bg_task
    unless session[:bg_task_id].nil?
	    task = BgTask.find_by_id(session[:bg_task_id])
	    unless task.nil?
  	    if task.completed?
  	      event = task.obj_type.camelize.constantize.find(task.obj_id)
  	      flash[:good] = "Pictures for #{event.party.title} at #{event.venue.name} are ready for viewing and editing."
  	      task.destroy
  	      session[:bg_task_id] = nil
  	    end
  	  end
	  end
  end
end