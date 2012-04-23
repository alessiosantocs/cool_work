class RegionController < ApplicationController
	def initialize
	  super
  end
  
	def show
		unless @region_name.nil?
		  @page_title << "#{@region.full_name} Home"
			@breadcrumb.drop_crumb(@region.full_name)
			@page_title << " :: #{@region.full_name}"
      1.upto(5){|i| add2ads "120x120_frontpage#{i}" } #inhouse ads for the frontpage
      add2ads "336x280_frontpage"
      add2ads "120x600_ros"
		else
			flash[:bad] = "That area does not exist. Choose another." unless request.subdomains.first.to_s =~ /www/
			redirect_to "http://www.#{SITE.url}/"
		end
	end
end