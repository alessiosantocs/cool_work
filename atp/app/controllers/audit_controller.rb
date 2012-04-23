class AuditController < ApplicationController
  session :off
  skip_before_filter :site_data
  
  def recent
    show = []
    params[:show].each{|k,v| show << k if v=='1' } if params[:show].size > 0
    limit = (params[:l].nil? ? 50 : params[:l].to_i)
    audits = Audit.recent( show, limit)
    respond_to do |wants|
			wants.js  { render :inline => audits.to_json }
		end
  end
  
  def list
    show = []
    params[:show].each{|k,v| show << k if v=='1' } if params[:show].size > 0
    limit = (params[:l].nil? ? 10 : params[:l].to_i)
    since = params[:since].to_f
    audits = Audit.logs_since(since, show, limit)
    ajax_response "serverTime= parseFloat("+ (("%10.5f" % Time.now.utc.to_f).to_f * 1000).to_s + "); list= #{audits.collect{| audit | AuditPublic.new(audit) }.to_json};", true
  end
  

  def post
    Stat.create(:obj_type => params[:type], :obj_id => params[:id], :region_id => params[:rid], :act => params[:act], :site_id => params[:sid], :user_id => params[:uid] || 0) unless params[:type].nil? or params[:id].nil?
    render :nothing => true
  end
  alias :l :post
end
