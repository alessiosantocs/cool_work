class FlyerController < Merb::Controller
  #before :get_region_and_site
  
  def show
    render_no_layout
  end
  
  def js
    get_region_and_site
    @flyers = []
    return if params[:city].nil?
    limit = (params[:n].to_i === 1..5 ? params[:n].to_i : 3)
    @flyers = @site.parties.find(:all, :conditions => ["parties.active=1 AND city_id in (?) AND flyers.days_left > 0", params[:city] ], :limit => limit, :include => [:flyer] )
    @orient = (params[:orient].to_s == 'h' ? 'h' : 'v')
    render_js "js"
  end 
  alias :ad :js
  
  def upload
    puts params.inspect
    
    FileUtils.mv params[:data][:tempfile].path, 
                 Merb::Server.config[:dist_root]+"/public/files/#{params[:data][:filename]}"
    render_no_layout
  end
  
  def progress
    puts params.inspect
    Mongrel::Uploads.debug = true
    @upstatus = Mongrel::Uploads.check(params[:upload_id])
    render_js 'progress'
  end
  
  def file
    send_file DIST_ROOT+'/public/files/'+params[:file]
  end
  
  private
  def get_region_and_site
    @site = Site.find_by_url(params[:domain])
    @region = @site.regions.find_by_short_name(params[:region])
  end
end