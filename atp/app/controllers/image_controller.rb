class ImageController < ApplicationController
	layout nil
	before_filter :login_required
	
	def show
	  @img = Image.find(params[:id])
	  @type = params[:type] || nil
		render :inline => "<%= show_img(@img, @type) -%>"
	end
end