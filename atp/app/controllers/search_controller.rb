class SearchController < ApplicationController
  skip_before_filter :site_data
  #caches_page :index, :results
  helper :region
  def initalize
    super
  end
  
  def index
    reset_ads
    add2ads "728x90_homepage"
    add2ads "336x280_homepage"
    @page_title = "Your ultimate list of parties"
  end
  
  def results
  end
end