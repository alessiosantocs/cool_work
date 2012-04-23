class CustomersController < ApplicationController
  ssl_required :new, :create, :edit
  ssl_allowed :update
  before_filter :login_required, :except =>  [:create, :new]
  
  #due to my current Ruby naivete, even though the models allow multiple address/location associates with a customer
  #the controller is limited to 1:1 for now.
  
  # render new.rhtml
  def new
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    @customer = Customer.new
    #@user = User.new
    @user = User.new(:invitation_token => params[:invitation_token])
    if @user.invitation
      @user.email_confirmation = @user.invitation.recipient_email
      @user.first_name = @user.invitation.first_name
      @user.last_name = @user.invitation.last_name
      referrer = User.find(:all, :conditions => {:id => @user.invitation.sender_id})[0]
      @user['referrer'] = referrer.email
    end
    @building = Building.new
    @building.zip = params[:zip]
    @address = Address.new

  end
  
  def create
    cookies.delete :auth_token
    reset_session
    @customer = Customer.new(params[:customer])
    @user = @customer.build_user(params[:user])
    @user.user_class = "customer"
    invitation = Invitation.find_by_recipient_email(@user.email)
    unless invitation.blank?
      referrer = User.find(invitation.sender_id)
      @user.referrer = referrer.email
      @user.invitation_id = invitation.id
    end
    @customer_preferences = @customer.build_customer_preferences()
    @building = Building.find_or_initialize(params[:building])
    @address = @customer.addresses.build(params[:address])
    @address.building = @building

    if @customer.save
      self.current_user = User.authenticate(params[:user][:email], params[:user][:password])
      Notifier.deliver_signup_thanks(self.current_user)
      redirect_to fresh_order_customer_path(@customer)
      flash[:signup_message] = SIGN_UP_MESSAGE
    else
      render :action => 'new'
    end
    #cookies.delete :auth_token
    #reset_session

    #@customer = Customer.new(params[:customer])
    #@user = @customer.build_user(params[:user])
    #@user.user_class = "customer"
    #@customer_preferences = @customer.build_customer_preferences()
    #@building = Building.find_or_initialize(params[:building])
    #@address = @customer.addresses.build(params[:address])
    #@address.building = @building

    #@credit_card = CreditCard.new(params[:credit_card])
    #@credit_card.expiration = params[:exp_month] + params[:exp_year]
    #@credit_card.payment_method = params[:credit_card][:payment_method]
    #@credit_card.first_name = @user.first_name
    #@credit_card.last_name = @user.last_name
    #@credit_card.address = @address.addr1
    #@credit_card.city = @address.city
    #@credit_card.state = @address.state
    #@credit_card.zip = @address.zip
    #begin
      #Customer.transaction do
        #respond_to do |format|
          #if @customer.save
           # @credit_card.customer_id = @customer.id
            #raise "Invalid credit card" unless @credit_card.save 
            #if @credit_card.save 
             # @customer.credit_cards << @credit_card
              #self.current_user = User.authenticate(params[:user][:email], params[:user][:password])
              #Notifier.deliver_signup_thanks(self.current_user)
              #format.html { redirect_to fresh_order_customer_path(@customer)}
              #flash[:signup_message] = "Thank you for signing up. In order to better serve you, we ask many questions up front to better serve you. Once you have set your preferences, you will no longer need to define or describe each order. However, the option will always be available."
            #else
              #format.html { render :action => :new }
              #format.xml  { render :xml => @credit_card.errors, :status => :unprocessable_entity }
            #end
          #else
            #format.html { render :action => 'new' }
          #end
        #end
      #end
    #rescue Exception => e
      #flash["errors"] = e.message
      #render :action => :new
    #end
  end
  
  # After Account Creation, user taken to the "Set Preferences Now" page. This page describes (in text
  # format) what the user can expect by setting his preferences, and gives him
  # the option to either set the preferences now, or to set them later
  def preference_choice
    @customer = Customer.find(params[:id])
  end
  
  def dashboard
    @customer = Customer.find(params[:id]) if current_user.employee?
  end

  def invitations
    @invitation = Invitation.new
    @customer = Customer.find(params[:id])
    @registered = @customer.registered_invitees()
    @unregistered = @customer.unregistered_invitees()
    @promotion = ContentPromotion.paginate(:all, :conditions => ["expiry_date >= ? AND title = 'My Referral Program'", Date.today.strftime("%Y-%m-%d")], :per_page => 10, :page => params[:page], :order => "updated_at desc")
#     @freshcash = @customer.fresh_cash_invitees()
  end

  def request_invitations
    @customer = Customer.find(params[:id])
    if @customer.account.invitation_limit == 0 and @customer.account.invitation_count < (@customer.account.invitation_max-10)
      @customer.account.invitation_limit = 10
      @customer.account.invitation_count = @customer.account.invitation_count + 10
      @customer.save
      t = true
    else
       flash['error'] = 'You are not eligible for new invitations yet...!'
   end
   
   respond_to do |format|
      format.html #
      format.js {
        render :update do |page|
          if t == true
            page.replace_html 'num_invites', '(10 Invitations Remaining)'
            page.hide "irequest"
            page.show "invite"
          else
            page.show 'irequest'
          end
        end
      }
    end
  end
  
  def preferences
    @customer = Customer.find(params[:id])
    @customer_preferences = @customer.preferences
    @current_recurrings = @customer.recurring_order
  end
  
  def ecologic
    @customer = Customer.find(params[:id])
  end
  
  def redeem
    @customer = Customer.find(params[:id])
    @customer.give_fresh_cash_for_eco_points
    redirect_to :action => 'ecologic'
  end
  
  def buy_credit
    @customer = Customer.find(params[:id])
    @carbon = params[:carbon_credit].to_i
    @water = params[:water_credit].to_i
    if @carbon < 1 and @water < 1
      render :action => 'ecologic'
      flash[:error] = "There was a problem with your order"
    else
      @order = Order.create_eco(@carbon, @water, {:customer => @customer})
      redirect_to payment_customer_order_path(@order.customer, @order)
      flash[:notice] = "Your eco-logic was successfully updated"
    end
  end
  
  def fresh_order
    @customer = Customer.find(params[:id])
    @show_preferences = params['set-preferences'] == 'true'
    @customer_preferences = @customer.preferences
#     @services = Service.find(:all)
    @services = Service.active_services
  end
  
  def create_order
    customer = Customer.find(params[:id])
#     services = Service.find(:all)
    services = Service.active_services

    @order = Order.new(:customer => customer)
    @order.premium = params[:premium][:yes]
    
    for service in services
      if params['service_'+service.id.to_s] == 'on'
        for item_type in service.applicable_item_types
          position_ids = params['item_details_'+item_type.id.to_s].keys if service.detailable? && item_type.name != 'Miscellaneous' && item_type.is_active.to_i == 1
          for i in 1..params['quantity_item_type_'+item_type.id.to_s].to_i
            if service.detailable? && !position_ids[i-1].blank? 
              pos_id = position_ids[i-1].to_s
              customer_item = CustomerItem.new(params['customer_item_type_'+item_type.id.to_s+'_'+pos_id])
              @instruction = Instructions.create(params['instructions_item_type_'+item_type.id.to_s+'_'+pos_id])
              customer_item.instructions_id = @instruction.id 
            else
              customer_item = CustomerItem.new()
            end
            customer_item.customer = customer
            customer_item.item_type = item_type
            price = Price.find(:first, :conditions=> ["item_type_id = ? AND service_id = ?", item_type.id.to_s, service.id.to_s])
            is_premium = ( customer_item.premium || @order.premium )
            customer_item.plant_price = price.get_plant_price(is_premium, params['weight_item_type_'+item_type.id.to_s].to_i)
            @order.order_items.build(:customer_item => customer_item, :service_id => service.id, :weight => params['weight_item_type_'+item_type.id.to_s].to_i)
          end
        end
      end
    end
    if @order.save
      #      if customer.goto_url.blank? or customer.goto_url == 'scheduling'
      redirect_to schedule_customer_order_path(customer, @order)
      #      else
      #        redirect_to customer_orders_path(customer) + '?order='+@order.id.to_s+'#current'
      #      end
    else
      @show_preferences = params['set-preferences'] == 'true'
      @customer_preferences = customer.preferences
#       @services = Service.find(:all)
      @services = Service.active_services
      render :action => 'fresh_order'
      flash[:error] = "There was a problem with your order"
    end
  end
  
  #I tried to merge creation/editing into one controller, but there are background variables preventing me from
  #doing so, (for example, no matter what :action I specify in the form_for function of the view, it insists that
  #the action is "update"...), more recently if an :id is not specified, it defaults to :action => show, but it
  #did not do this in previous iterations.  I suspect it must have something to do with routing.
  def edit
    @customer = Customer.find(params[:id])
    @user = @customer.user
    @address = @customer.addresses[0]
    @building = @address.building
  end
  
  #I suppose I need to get sessioning up and running before I can finish this function.  (Unless I want to re-lookup)
  #all the relevent information from the database, replace it with the :params, and then resave! it.
  def update
    @customer = Customer.find(params[:id])
    @user = @customer.user
    @address = @customer.addresses[0]
    @building = @address.building
    if @customer.update_attributes(params[:customer]) && @user.update_attributes(params[:user]) && @address.update_attributes(params[:address]) && @building.update_attributes(params[:building])
      redirect_to :back
     # redirect_back_or_default(:action => 'edit') 
      flash[:notice] = "Account details successfully saved"
    else
      render :action => :edit
    end
  end
  
  def update_recurring
    @customer = Customer.find(params[:id])
    recurring = @customer.recurring_order 
    if recurring.nil?
      recurring = RecurringOrder.new(params[:recurring])
      recurring.customer = @customer
      recurring.save
    else
      recurring.update_attributes(params[:recurring])
    end
    
    redirect_to customer_orders_path(@customer) 
    flash[:notice] = "Your recurring times were updated"
  end
  
  #this is also being bitten by the "the :action is show" bug if you don't specify an :id (which in this case is
  #meaningless anyways.)
  def view
    @customers = Customer.find(:all)
    @columns_to_display = [ :last, :first, :company ]
  end
  
  def delete_recurring
    @current_recurring= RecurringOrder.find(params[:id])
    #Order.find(:first ,:conditions=>["id = ? " ,@current_recurring.last_order_id])
    @current_recurring.delete
    redirect_to preferences_customer_path(@current_recurring.customer_id)
  end
  def edit_recurring
    @current_recurring= RecurringOrder.find(params[:id])
    @pick_up_time = @current_recurring.last_order.requests.first.stop.window.start.strftime('%I:%M %p')
    @pick_up_time <<"--"
    @pick_up_time << (@current_recurring.last_order.requests.first.stop.window.end + 1.second).strftime('%I:%M %p')
    @delivary_time = @current_recurring.last_order.requests.last.stop.window.start.strftime('%I:%M %p')
    @delivary_time <<"--"
    @delivary_time <<(@current_recurring.last_order.requests.last.stop.window.end + 1.second).strftime('%I:%M %p')
    @customer = Customer.find(@current_recurring.customer_id)
    @order = Order.find(@current_recurring.last_order)
    @order.customer = @customer

    @windows = Window.find_all_regular
    @selected_location = @customer.primary_address.parent_location.parent_location
    session[:calendar_day] = params[:date].blank? ? Time.now.to_date : params[:date].to_date  
    @from_date = params[:date].blank? ? Time.now.to_date : params[:date].to_date  if current_user.employee?
#    @t = Time.now - (60*60*4)
    respond_to do |format|
      format.html #
      format.js {
        if params[:express] == 'false'
          @delivery_schedules = Schedule.for_week_of(@selected_location, @order.earliest_deliverable(session[:calendar_day]), params[:start])
        else
          @delivery_schedules = Array.new
          @delivery_schedules << @order.express_delivery_schedule(@selected_location, session[:calendar_day] || Time.now.to_date, params[:start])
        end
        render :update do |page|
          page.replace_html "order_delivery", :partial => 'delivery', :locals => {:pickup => false, :schedules => @delivery_schedules}
        end
      }
    end
  end
  def update_recurring_order
   @current_recurring= RecurringOrder.find(params[:id])
   @current_recurring[:interval]=7 if params[:recurring]=="weekly"
   @current_recurring[:interval]=14 if params[:recurring]=="two_weeks"
   @current_recurring[:interval]=28 if params[:recurring]=="four_weeks"
   unless params[:pickup].blank?
   pick_up_array = params[:pickup].split("_")
   pick_up_time = pick_up_array[0]
   pick_up_index = pick_up_array[1]
   pick_up_index = (pick_up_index.to_i < 2) ? pick_up_index.to_i + 1 : pick_up_index.to_i + 4
   end 
   unless params[:delivery].blank?
   delivery_array = params[:delivery].split("_")
   delivery_time = delivery_array[0]
   delivery_index = delivery_array[1]
   delivery_index = (delivery_index.to_i < 2) ? delivery_index.to_i + 1 : delivery_index.to_i + 4
   end
   @current_recurring.last_order.requests.first.stop.update_attributes(:date=>pick_up_time) unless pick_up_time.nil?
   @current_recurring.last_order.requests.last.stop.update_attributes(:date=>delivery_time) unless delivery_time.nil?
   @current_recurring.last_order.requests.first.stop.update_attributes(:window_id=>pick_up_index) unless pick_up_index.nil?
   @current_recurring.last_order.requests.last.stop.update_attributes(:window_id=>delivery_index) unless delivery_index.nil?
   @current_recurring.update_attributes(:pickup_time=>pick_up_index) unless pick_up_index.nil?
   @current_recurring.update_attributes(:delivery_time=>delivery_index) unless delivery_index.nil?
   @current_recurring.save
   redirect_to preferences_customer_path(@current_recurring.customer_id)
  end
end
