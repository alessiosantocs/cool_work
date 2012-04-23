class PageController < ApplicationController
	session :off, :only => [ :missing ]
	caches_page :missing
	before_filter :layout_type, :except => [ :missing ]
	
	def initialize	
	  super
		@breadcrumb = Breadcrumb.new
	end
	
	def tos
		@breadcrumb.drop_crumb("Terms of Service ")
	end
	
	def privacy
		@breadcrumb.drop_crumb("Privacy")
	end
	
	def syndicate
		@breadcrumb.drop_crumb("Syndicate")
	end
	
	def overview
		@breadcrumb.drop_crumb("Company Overview and Advertising Information")
	end
	
	def listing_details
	end
	
	def test
	  render :layout => false
	end
	
	def value
	  ajax_response "#{params[:value]}", true
	end
	
	private
	def layout_type
  	render :layout => "slim" unless params[:slim].nil?
	end
end