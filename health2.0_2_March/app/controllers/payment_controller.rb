class PaymentController < ApplicationController


require 'rubygems'
require 'active_merchant'
require 'json'


  # Use the TrustCommerce test servers


def SubscribtionPage
    @subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
    @admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
	@a_str = "false"
    if @admin.to_s != "" 
       @a_str = params[:a_str]
       @subscribed = true 
    end 
    
     respond_to do |format|
      format.html
      format.xml  # index.xml.builder
     end
end 

def processPayment
  # ActiveMerchant::Billing::Base.mode = :test

  # ActiveMerchant accepts all amounts as Integer values in cents
  # $10.00
  amount = 1000

  # The card verification value is also known as CVV2, CVC2, or CID
  credit_card = ActiveMerchant::Billing::CreditCard.new(
                  :first_name         =>  params[:firstName],
                  :last_name          =>  params[:lastName],
                  :number             =>  params[:cardNumber],
                  :month              =>  params[:month],
                  :year               =>  params[:year],
                  :verification_value => params[:cvcnumber]
                )

  @pArray = {}
  @pArray["bCreditCard"] = false
  @pArray["bSuccess"] = false

  # Validating the card automatically detects the card type
  if credit_card.valid?
    @pArray["bCreditCard"] = true
    # Create a gateway object for the TrustCommerce service
    #gateway = ActiveMerchant::Billing::Base.gateway(:authorize_net).new(
    #            :login => '45F5LUed3',
    #            :password => '4V558D5ee4Wd53ue',
    #            :test => 'true' 
    #          )
    gateway = ActiveMerchant::Billing::Base.gateway(:authorize_net).new(
                :login => '45F5LUed3',
                :password => '4V558D5ee4Wd53ue',
                :test => 'true' 
              )


    # Authorize for the amount
    response = gateway.purchase(amount, credit_card)
    logger.info(response)
    if response.success?
      @pArray["bSuccess"] = true
    
      @pArray["message"] = response.message
      @user_attribute = UserAttribute.new({"User"=> current_user, "name" => "subscribed"})
	  @user_attribute.save
    else
	  @pArray["bSuccess"] = false
      @pArray["message"] = response.message
      #please verify your payment information or 
    end
  end 
  
    respond_to do |format|
      format.xml  # processPayment.xml.builder
    end
 end 







end
