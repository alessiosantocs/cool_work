class SiteController < ApplicationController
  def initialize
    @page_title = String.new
    @menu_section = "site"
    @breadcrumb = Breadcrumb.new
    @breadcrumb.drop_crumb("Site", "/site")
  end

  def index
    @sites =Site.find :all  
  end

  def create
    @breadcrumb.drop_crumb("Create")
    @page_title << " Create a new site"
    case request.method
      when :post
        @site = Site.new(params[:site])
        if @site.save
          flash['good'] = "Congrats... New Site... "
          redirect_to :action => 'show', :id => @site.id
        else
          flash['bad'] = "Sorry Wanker... Try Again..."
        end
      when :get
        generate_blank_for_new_site
    end
  end

  def update
    verify_site
    @breadcrumb.drop_crumb("Update")
    @page_title << " Update site"
    case request.method
      when :post
        if @site.update_attributes(params[:site])
          flash['good'] = "Congrats... #{@site.full_name} Updated"
          redirect_to :action => 'show', :id => @site.id
        else
          flash['bad'] = "Sorry Wanker... Try Again..."
        end
    end
  end

  def drop
    verify_site
    @site.destroy
    redirect_to :action => 'index'
  end

  def show
    verify_site
  end
  
  protected
  def verify_site
    @site_id = params[:id]
    begin
      @site = Site.find(@site_id)
    rescue ActiveRecord::RecordNotFound
      render :text => "Site not found", :status => 404
      return
    end
  end

  #Generate a template for certain actions on get
  def generate_blank_for_new_site(options = {})
    @site = Site.new({ 
      :short_name => nil, 
      :full_name => nil, 
      :url => nil, 
      :comments_allowed => true,
      :active => true })
  end
end
