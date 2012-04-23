class CoverImageController < ApplicationController
  layout "application", :except => [:js]
  before_filter :regional_rep_required, :except => [:js]
  helper ImageHelper
	
	def initialize
	  super
		@page_title = ""
		@breadcrumb = Breadcrumb.new
		@menu_section = "mypage"
	end

  def create
    if request.post?
      @cover_image = CoverImage.blank(params[:cover_image])
      @cover_image.site_id = SITE_ID
      if @cover_image.save
        expire_page(:controller => "region", :action => "show", :action_suffix => "new_parties")
        flash[:good] = "New cover image added."
      else
        flash[:bad] = "No cover image added."
      end
    else
      @cover_image = CoverImage.blank
    end
  end
  
  def index
    render :action => :list
  end

  def find
    v = params[:cover_image]
    @cover_images = CoverImage.find(:all, :conditions => ["active=? AND city_id=? AND site_id=?", v[:active], v[:city_id], v[:site_id] ] )
    render :partial => "cover_image", :collection => @cover_images
  end
  
  def upload
    if request.post?
      images = %r/jpg|jpeg/i
      file = params[:file][:images]
      # create image directory path
      img_path = SETTING['image_server']['path']+"/cover_image/" # create image directory path
      img_base_url = SETTING['image_server']['base_url']+"/cover_image/"
      FileUtils.mkdir_p(img_path)
      if file.content_type.chomp =~ images
        # handle individual file
        f = file.path
        @image = Image.store(f, 'CoverImage', img_path, img_base_url, session[:user][:id])
      else
        fc = FileCollection.new(file.local_path, file.original_filename.sub(/.*?((\.tar)?\.\w+)$/, '\1')).process
        fc.find(images).each do |f|
          # handle individual file
          @image = Image.store(f, 'CoverImage', img_path, img_base_url, session[:user][:id])
        end
        fc.delete
      end
      responds_to_parent do
        render :update do |page|
          page << "$('image_form').hide(); Form.enable('cover_image_form'); new Message('Image Uploaded.', 'good'); $('cover_image_image_id').value = #{@image.id};"
        end
      end
    end
  end
  
  def destroy
    cover = CoverImage.find(params[:id]) rescue nil
    unless cover.nil?
      cover.destroy
      render :inline => "success"
    else
      render :inline => "failure"
    end
  end
end