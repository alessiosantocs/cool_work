class StaticController < ApplicationController
  layout 'staging'
  ssl_required :home, :logreg
  
  def home
    @tickers = Ticker.find(:all, :order => "updated_at desc", :conditions => ["expiry >= ?", Date.today])
    @promotions = ContentPromotion.find(:all, :order => "updated_at desc", :conditions => ["expiry_date >= ?", Date.today.strftime("%Y/%m/%d")])
  end
  
  def agreement
    respond_to do |format|
      format.html { render :action => "agreement.html.erb", :layout => false }
    end
  end
  
  def about
  end
  
  def how_it_works
  end
  
  def prices
    @services = Service.find(:all)
    render :layout => false
  end
  
  def five_points
    render :layout => false
  end
  
  def seven_stages
    render :layout => false
  end
  
  def delivery_fees
    render :layout => false
  end
  
  def insurance
    render :layout => false
  end
  
  def customize_example
    render :layout => false
  end
  
  def logreg
    render :layout => 'zip'
  end
  
  def servicearea
    render :layout => false
  end
  
  def send_message
    type = params[:type]
    service = 'service@myfreshshirt.com' if type == '1'
    service = 'order@myfreshshirt.com' if type == '2'
    service = 'pickupanddelivery@myfreshshirt.com' if type == '3' 
    service = 'payment@myfreshshirt.com' if type == '4'
    customer = params[:your_email]
    message = params[:text]
    
    if message.blank? || customer.blank?
      flash[:error] = "Please type in your email address and your inquiry"
      render :action => "contact_us"
    else
      Notifier.deliver_contact_message(customer, service, message)
      flash[:notice] = "Your inquiry has been sent"
      redirect_to "/contact_us"
    end
  end

  def news
    @news = News.paginate(:all, :per_page => 10, :page => params[:page], :order => "updated_at desc")
  end

  def fresh_promotions
    @promotions = ContentPromotion.paginate(:all, :conditions => ["expiry_date >= ?", Date.today.strftime("%Y-%m-%d")], :per_page => 10, :page => params[:page], :order => "updated_at desc")
  end
  
  def eco_point
  end
  
end
