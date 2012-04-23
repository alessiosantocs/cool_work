class ApplicationController < Merb::Controller
  def get_region_and_site
    @site = Site.find_by_url(params[:domain])
    @region = @site.regions.find_by_short_name(params[:region])
  end
end