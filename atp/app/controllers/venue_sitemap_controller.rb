class VenueSitemapController < ApplicationController
  layout nil
  before_filter :serve_xml, :set_host
  caches_page :index

  def index
    @venues = Venue.find(:all, :conditions => "city_id > 0", :order => "active desc", :limit => 50000)
    respond_to do |format|
      format.xml { render :file => "venue/sitemap", :use_full_path => true }
    end
  end

  protected
  def serve_xml
    headers['Content-Type'] = "application/xml"
  end

  def set_host
    @host = request.host_with_port
  end
end