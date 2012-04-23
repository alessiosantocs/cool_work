class FlagController < ApplicationController
  skip_before_filter :site_data
	before_filter :login_required
	before_filter :objs_required, :only => [:add]
	before_filter :super_admin_required, :except => [:add]
	
  def add
    if SETTING["flaggable"].include?(@obj_type) and (params[:inappropriate].nil? or params[:spam].nil?)
      f = Flag.blank(:obj_type => @obj_type, :obj_id => @obj_id, :user_id => session[:user][:id], :inappropriate => params[:inappropriate] || false, :spam => params[:spam] || false )
      f.save
      ajax_response "#{@obj_type} Flagged.", true
    else
      ajax_response "Not Flagged"
    end
  end
  
  def show    
    @flag = Flag.find(params[:id] )
    respond_to do |wants|
      wants.js{ render :inline => @flag.to_json }
    end
  end
    
  def list
    limit = (params[:l].nil? ? 25 : params[:l].to_i)
    @flag = Flag.find_recent_comments(limit)
    @flag.each{|f| f.comment.commentable.image}
    respond_to do |wants|
      wants.js{ render :inline => @flag.to_json }
    end
  end
  
  def update_list
    flag_ids = params['clear'].keys
    return_ids = []
    flag_ids.each do |f|
      if params['delete'][f] == '1'
        flag = Flag.find(f.to_i) rescue nil
        return_ids << f
        flag.destroy_comment unless flag.nil?
      elsif params['clear'][f] == '1'
        flag = Flag.find(f.to_i) rescue nil
        return_ids << f
        flag.clear_all unless flag.nil?
      end
    end
    respond_to do |wants|
      wants.js{ render :inline => return_ids.to_json }
    end
  end
end