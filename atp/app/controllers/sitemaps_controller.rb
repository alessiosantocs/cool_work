class SitemapsController < ApplicationController
  layout nil
  before_filter :serve_xml, :set_host
  caches_page :index
  
  def index
    @maps = []
    @sitemaps = Dir.glob("./app/views/*/sitemap.rxml").entries
    @sitemaps.each {|s| @maps << s.sub("./app/views/",'').gsub(/\.rxml$/, '.xml')}
    render 'sitemap'
  end
  
  protected
  
  def serve_xml
    headers['Content-Type'] = "application/xml"
  end
  
  def set_host
    @host = request.host_with_port
  end
end