class Admin::ContentController < ApplicationController
  require_role "content"
  
  def index
      redirect_to '/admin/content/site'
  end
  
  def site
    @content = Content.find_or_create_by_id(1)
  end
  
  def home
    @content = Content.find_or_create_by_id(1)
  end
  
  def promotions
    @content_promotions = ContentPromotion.find(:all, :order => "updated_at desc")
    render :template => 'admin/content_promotions/index'
#     @promotion = Promotion.new()
#     @promotions = Promotion.find(:all)
  end
  
  def news
    @news = News.find(:all, :order => "updated_at desc")
    render :template => 'news/index'
  end

  def tickers
    @tickers = Ticker.find(:all, :order => "updated_at desc")
    render :template => 'tickers/index'
  end
  
  def update
    @content = Content.find_or_create_by_id(1)
    
    respond_to do |format|
      if @content.update_attributes(params[:content])
        flash[:notice] = 'Content was successfully updated.'
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "home" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
