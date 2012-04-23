class <%= controller_class_name-%>SitemapController < ApplicationController
  
  layout nil
  
  #Stick these in your routes.rb
  #map.with_options(:controller => "<%= controller_file_name -%>_sitemap") do |sitemap|
  #  sitemap.index '<%= controller_file_name -%>/sitemap.xml', :action => 'index'
  #end
  #map.sitemaps '/sitemaps.xml', :controller => 'sitemaps', :action => 'index'
  
  before_filter :serve_xml, :set_host
      
  caches_page :index

  def index
    @<%= table_name -%> = <%= controller_class_name.singularize -%>.find :all, :limit => 50000
    respond_to do |format|
      format.xml { render "<%= controller_file_name %>/sitemap" }
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