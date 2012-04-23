class AuditController < Merb::Controller
  def list
    show = []
    params[:show].each{|k,v| show << k if v=='1' } if params[:show].size > 0
    limit = (params[:l].nil? ? 10 : params[:l].to_i)
    since = params[:since].to_f
    @audits = Audit.logs_since(since, show, limit)
    render_js
  end
  
  def log
    Stat.create(:obj_type => params[:type], :obj_id => params[:id], :region_id => params[:rid], :act => params[:act], :site_id => params[:sid], :user_id => params[:uid] || 0) unless params[:type].nil? or params[:id].nil?
    render_nothing
  end
  alias :l :log
end
