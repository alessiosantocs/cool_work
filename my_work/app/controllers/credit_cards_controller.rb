class CreditCardsController < ApplicationController
  ssl_required :edit, :update, :new, :create
  before_filter :login_required
  filter_parameter_logging :number
  
  def index
    @customer = Customer.find(params[:customer_id])
  end
  
  def new
    @customer = Customer.find(params[:customer_id])
    @credit_card = CreditCard.new
    
    address = @customer.primary_address
    @credit_card.address = address.addr1
    @credit_card.city = address.city
    @credit_card.state = address.state
    @credit_card.zip = address.zip
    @credit_card.first_name = @customer.first_name
    @credit_card.last_name = @customer.last_name
  end
  
  def edit
    @credit_card = CreditCard.find(params[:id])
    @customer = Customer.find(params[:customer_id])
  end
  
  def create
    @customer = Customer.find(params[:customer_id])
    @credit_card = CreditCard.new(params[:credit_card])
    @credit_card.expiration = params[:exp_month] + params[:exp_year]
    @credit_card.payment_method = params[:credit_card][:payment_method]
    cc=params[:credit_card][:number]
    card_number = "XXXXXXXXXXXX" 
    card_number +=cc[cc.length-4,cc.length]   
    @credit_card.last_four_digits = card_number
    @building = Building.new
    @building.city = params[:credit_card][:city]
    @building.addr1 = params[:credit_card][:address]
    @building.state = params[:credit_card][:state]
    @building.zip = params[:credit_card][:zip]
    @credit_card.building = @building
    respond_to do |format|
      if @customer.credit_cards << @credit_card
        flash[:notice] = @credit_card.response_code
        format.html { redirect_to customer_credit_cards_path(@customer) }
        format.xml  { render :xml => @credit_card, :status => :created }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @credit_card.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @credit_card = CreditCard.find(params[:id])
    @customer = @credit_card.customer
    @credit_card.expiration = params[:exp_month] + params[:exp_year]
    @credit_card.payment_method = params[:credit_card][:payment_method]
    
    respond_to do |format|
      if @credit_card.save
        flash[:notice] = @credit_card.response_code
        format.html { redirect_to customer_credit_cards_path(@customer) }
        format.xml  { render :xml => @credit_card, :status => :created }
      else
        flash[:error] = @credit_card.errors
        format.html { render :action => :edit }
        format.xml  { render :xml => @credit_card.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @credit_card = CreditCard.find(params[:id])
    customer = @credit_card.customer
    puts ">>>>>>>> -- destroy --" + @credit_card.payment_profile_id.to_s
    if @credit_card.payment_profile_id.to_s != ''
      @credit_card.authdonet_delete     
    end
    @credit_card.destroy
    
    flash[:notice] = 'The selected card was successfully deleted'
    
    respond_to do |format|
      format.html { redirect_to customer_credit_cards_path(customer) }
      format.xml  { head :ok }
    end
  end
  
end
