# == Schema Information
# Schema version: 98
#
# Table name: credit_cards
#
#  id                 :integer(11)   not null, primary key
#  customer_id        :integer(11)   
#  payment_method     :string(255)   
#  last_four_digits   :string(255)   
#  name               :string(255)   
#  payment_profile_id :string(255)   
#  default            :boolean(1)    
#  created_at         :datetime      
#  updated_at         :datetime      
#

class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many   :payments
  belongs_to :building
  
  validates_presence_of :payment_method, :number, :first_name, :last_name, :address, :city, :security_code , :state, :zip, :expiration
  validates_inclusion_of :payment_method, :in => ['Visa', 'Mastercard', 'American Express', 'Discover']
  validates_associated :customer
  validates_format_of :expiration, :with => /\d{4}/
  
  attr_accessor(:payment_method, :number, :name, :address, :first_name, :last_name, :city, :state, :zip, :user_profile)
  attr_reader(:expiration, :message, :result, :response_code, :response_reason_text)
      @@MODE = (RAILS_ENV == 'production' ? :production : :testing )
  @@AUTHDOTNETAPINS = 'AnetApi/xml/v1/schema/AnetApiSchema.xsd'
  if @@MODE == :production
    @@LOGIN_ID           = '34Smwrc5pTq'
    @@TRANSACTION_KEY    = '3g7W5Pq27N4s7wzL'
    @@AUTHDOTNET_GATEWAY = 'https://api.authorize.net/xml/v1/request.api'
  elsif @@MODE == :testing
    @@LOGIN_ID           = '57Vs8DHpQ64'
    @@TRANSACTION_KEY    = '597HR7GsaG2z94P3'
    @@AUTHDOTNET_GATEWAY = 'https://apitest.authorize.net/xml/v1/request.api'
  else raise Exception, "Invalid mode, must be :testing or :production"
  end
  
  def invalid(att, string = "is invalid")
    errors.add(att.to_s, string)
  end
  
  def validate
    if self.payment_method == 'Visa'
      invalid :credit_card_number unless self.number        =~ /4\d{12,15}/
      invalid :security_code      unless self.security_code =~ /\d{3}/
    elsif self.payment_method == 'American Express'
      invalid :credit_card_number unless self.number        =~ /3\d{14}/
      invalid :security_code      unless self.security_code =~ /\d{4}/
    elsif self.payment_method == 'Mastercard'
      invalid :credit_card_number unless self.number        =~ /5\d{15}/
      invalid :security_code      unless self.security_code =~ /\d{3}/
    elsif self.payment_method == 'Discover'
      invalid :credit_card_number unless self.number        =~ /6\d{15}/
      invalid :security_code      unless self.security_code =~ /\d{3}/
    end
    unless self.customer.authdotnet_profile_id
      #customer does not have a CIM profile yet.
      self.createCustomerProfileRequest #create a new CIM customer profile with this credit card information
    end
    invalid :credit_card, @response_reason_text unless self.createCustomerPaymentProfileRequest
  end
  
  def amex?
    self.payment_method == 'American Express'
  end
  
  def store=(value = false)
    @store = value
  end
  
  def recurring=(value = false)
    @recurring = value
  end
  
  def expiration=(value) #value should be a string of MMYY format
    @expiration=value 
    puts ">>>>>>>>expiration : #{@expiration}"
  end
  
  def authorize(order)
    unless order.payment.transaction_id.nil?
      self.deleteCustomerProfileTransactionRequest(order)
    end
    self.createCustomerProfileTransactionRequest(:authorize_only, order)
  end
  
  def capture(order)
    self.createCustomerProfileTransactionRequest(:capture_only, order)
  end
  
  def payment_method=(val)
    write_attribute(:payment_method, val)
  end
  def payment_method
    read_attribute(:payment_method)
  end
  
  def authdonet_delete
    ppi = read_attribute(:payment_profile_id)
    self.deleteCustomerPaymentProfileRequest(ppi)
  end
  
  def response_code(as_string = true)
    if as_string
      return [nil, "approved", "declined", "error", "held for review"][@response_code.to_i]
    else
      return @response_code
    end
  end
  
  protected
  
  def before_save()
    self.createCustomerPaymentProfileRequest
  end
  
  def XMLHeader
    '<?xml version="1.0" encoding="utf-8"?>'
  end
  
  def merchantAuthenticationXML
    return '<merchantAuthentication><name>'+ @@LOGIN_ID +'</name><transactionKey>' + @@TRANSACTION_KEY  + '</transactionKey></merchantAuthentication>'
  end
  
  def createCustomerProfileRequest
    xml = '<createCustomerProfileRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
    xml += '<profile><merchantCustomerId>' + self.customer.id.to_s + '</merchantCustomerId><email>' + self.customer.account.email + '</email></profile>'
    xml += '</createCustomerProfileRequest>'
    response = self.send_to_authdotnet(xml)
    require 'rexml/document'
    dom = REXML::Document.new(response)
    dom.elements.each('createCustomerProfileResponse/messages/resultCode') do |element|
      #puts "Result Code = " + element.text.to_s
      if element.text.to_s == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
      end
    end
    dom.elements.each('createCustomerProfileResponse/messages/message/code') do |element|
      #puts "Result Message Code = " + element.text.to_s
    end
    dom.elements.each('createCustomerProfileResponse/messages/message/text') do |element|
      #puts "Result Message = " + element.text.to_s
    end
    dom.elements.each('createCustomerProfileResponse/customerProfileId') do |element|
      self.customer.authdotnet_profile_id = element.text.to_s
      self.customer.save!
      #puts element.text.to_s
    end
  end
  
  def createCustomerPaymentProfileRequest
    xml = '<createCustomerPaymentProfileRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
    xml += '<customerProfileId>' + self.customer.authdotnet_profile_id.to_s + '</customerProfileId>'
    xml += '<paymentProfile>'
    xml += '<billTo>' 
    xml +=   '<firstName>' + @first_name.to_s + '</firstName>'
    xml +=   '<lastName>' + @last_name.to_s + '</lastName>'
    xml +=   '<address>' + @address.to_s + '</address>'
    xml +=   '<city>' + @city.to_s + '</city>'
    xml +=   '<state>' + @state.to_s + '</state>'
    xml +=   '<zip>' + @zip.to_s + '</zip>'
    xml += '</billTo>'
    xml += '<payment>'
    xml +=   '<creditCard>'
    xml +=     '<cardNumber>' + (@number.strip).to_s + '</cardNumber>'
    xml +=     '<expirationDate>' + '20' + @expiration[2,4] + '-' + @expiration[0,2] + '</expirationDate>'
    xml +=   '</creditCard>'
    xml += '</payment>'
    xml += '</paymentProfile>'
    xml += '<validationMode>testMode</validationMode>' if @@MODE == :testing
    xml += '<validationMode>liveMode</validationMode>' if @@MODE == :production
    xml += '</createCustomerPaymentProfileRequest>'
    #puts "====REQUEST===="
    #puts xml
    #puts "==============="
    response = self.send_to_authdotnet(xml)
    #puts response
    require 'rexml/document'
    dom = REXML::Document.new(response)

    dom.elements.each('createCustomerPaymentProfileResponse/messages/message/resultCode') do |element|
      #puts "Result Message = " + element.text.to_s
      if element.text.to_s == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
      end
    end
    dom.elements.each('ErrorResponse/messages/resultCode') do |element|
      #puts "Result Message = " + element.text.to_s
      if element.text.to_s == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
        dom.elements.each('ErrorResponse/messages/message/text') do |element|
          #puts "Result Message = " + element.text.to_s
          @response_reason_text = element.text.to_s
          return false
        end
      end
    end
    dom.elements.each('createCustomerPaymentProfileResponse/customerPaymentProfileId') do |element|
      write_attribute(:payment_profile_id, element.text.to_s)
      self.save!
      #puts element.text.to_s
    end
    dom.elements.each('createCustomerPaymentProfileResponse/validationDirectResponse') do |element|
      @response = self.interpret(element.text.to_s)
    end
    @response
  end
  
  def getCustomerProfileRequest
    puts ">>>>>>>>>" + self.customer.authdotnet_profile_id.to_s
    if self.customer.authdotnet_profile_id.to_s != ''
    profile_id = self.customer.authdotnet_profile_id.to_s
    xml = '<getCustomerProfileRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
#    xml += '<refId>' + self.customer.id.to_s + '</refId>' 
    xml += '<customerProfileId>' + profile_id.to_s + '</customerProfileId>'
    xml += '</getCustomerProfileRequest>'
    response = self.send_to_authdotnet(xml)
    require 'rexml/document'
    dom = REXML::Document.new(response)
    dom.elements.each('getCustomerProfileResponse/messages/message/code') do |element|
      result_code = element.text.to_s
      puts ">>>>>>>>>>> res code: " + result_code
      if result_code == 'E00040':
        #self.customer.authdotnet_profile_id = nil
        #self.customer.save!
      end
    end
    dom.elements.each('createCustomerProfileResponse/messages/resultCode') do |element|
      #puts "Result Code = " + element.text.to_s
      if element.text.to_s == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
      end
    end
    dom.elements.each('createCustomerProfileResponse/messages/message/code') do |element|
      #puts "Result Message Code = " + element.text.to_s
    end
    dom.elements.each('createCustomerProfileResponse/messages/message/text') do |element|
      #puts "Result Message = " + element.text.to_s
    end
    dom.elements.each('createCustomerProfileResponse/customerProfileId') do |element|
      #puts element.text.to_s
    end
    end
  end
  
  def getCustomerPaymentProfileRequest
    @number = self.last_four_digits
    return unless self.number.blank?
    xml = '<getCustomerPaymentProfileRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
    xml += '<customerProfileId>' + self.customer.authdotnet_profile_id.to_s + '</customerProfileId>'
    xml += '<customerPaymentProfileId>' + self.payment_profile_id.to_s + '</customerPaymentProfileId>'
    xml += '</getCustomerPaymentProfileRequest>'
    
    response = self.send_to_authdotnet(xml)
    require 'rexml/document'
    dom = REXML::Document.new(response)
    dom.elements.each('getCustomerPaymentProfileResponse/messages/resultCode') do |element|
      #puts "Result Code = " + element.text.to_s
      if element.text.to_s == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
      end
    end
    dom.elements.each('getCustomerPaymentProfileResponse/messages/message/code') do |element|
      #puts "Result Message Code = " + element.text.to_s
    end
    dom.elements.each('getCustomerPaymentProfileResponse/messages/message/text') do |element|
      #puts "Result Message = " + element.text.to_s
    end
    dom.elements.each('getCustomerPaymentProfileResponse/customerProfileId') do |element|
      #puts element.text.to_s
    end
    
    profile_response = dom.elements['getCustomerPaymentProfileResponse']
    
    if !profile_response.nil? && profile_response.elements['messages'].elements['resultCode'].text != 'Error' #record not found
      billing = profile_response.elements['paymentProfile'].elements['billTo'].elements
      @first_name = billing['firstName'].text
      @last_name = billing['lastName'].text
      @address = billing['address'].text
      @city = billing['city'].text
      @state = billing['state'].text
      @zip = billing['zip'].text
      cc_info = dom.elements['getCustomerPaymentProfileResponse'].elements['paymentProfile'].elements['payment'].elements['creditCard'].elements
      #puts "CC_INFO",cc_info
      @number = 'XXXXXXXX' + cc_info['cardNumber'].text
      puts ">>>>>>>>>>>cc_xdate: #{cc_info['expirationDate']}"
      @expiration = cc_info['expirationDate'].text
      self.update_attribute(:last_four_digits , @number )
    end
  end
  
  def deleteCustomerProfileRequest
    puts ">>>>>>> -- deleteProfile --" + self.customer.id.to_s
    profile_id = self.customer.authdotnet_profile_id.to_s
    xml = '<deleteCustomerProfileRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
    xml += '<refId>' + self.customer.id.to_s + '</refId>'
    xml += '<customerProfileId>' + profile_id.to_s + '</customerProfileId>'
    xml += '</deleteCustomerProfileRequest>'
    response = self.send_to_authdotnet(xml)
    require 'rexml/document'
    dom = REXML::Document.new(response)
    dom.elements.each('createCustomerProfileResponse/messages/resultCode') do |element|
      #puts "Result Code = " + element.text.to_s
      result_code = element.text.to_s
      if result_code == 'Ok'
        self.customer.authdotnet_profile_id = nil
        self.customer.save!
      elsif result_code == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
      end
    end
    dom.elements.each('createCustomerProfileResponse/messages/message/code') do |element|
      #puts "Result Message Code = " + element.text.to_s
    end
    dom.elements.each('createCustomerProfileResponse/messages/message/text') do |element|
      #puts "Result Message = " + element.text.to_s
    end
    dom.elements.each('createCustomerProfileResponse/customerProfileId') do |element|
      #puts element.text.to_s
    end
  end
  
  def deleteCustomerPaymentProfileRequest(payment_profile_id)
    puts ">>>>>>> -- deleteProfile --" + self.customer.id.to_s
    profile_id = self.customer.authdotnet_profile_id.to_s
    xml = '<deleteCustomerPaymentProfileRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
    xml += '<customerProfileId>' + profile_id.to_s + '</customerProfileId>'
    xml += '<customerPaymentProfileId>' + payment_profile_id.to_s + '</customerPaymentProfileId>'
    xml += '</deleteCustomerPaymentProfileRequest>'
    response = self.send_to_authdotnet(xml)
    require 'rexml/document'
    dom = REXML::Document.new(response)
    dom.elements.each('createCustomerProfileResponse/messages/resultCode') do |element|
      #puts "Result Code = " + element.text.to_s
      if element.text.to_s == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
      end
    end
    dom.elements.each('deleteCustomerPaymentProfileResponse/messages/message/code') do |element|
      #puts "Result Message Code = " + element.text.to_s
    end
    dom.elements.each('deleteCustomerPaymentProfileResponse/messages/message/text') do |element|
      #puts "Result Message = " + element.text.to_s
    end
    dom.elements.each('createCustomerProfileResponse/customerProfileId') do |element|
      #puts element.text.to_s
    end
  end
  
  def createCustomerProfileTransactionRequest(tran_type, order)
    if order.total > 0.00
      tran_type = 'profileTransAuthOnly' if tran_type == :authorize_only
      tran_type = 'profileTransPriorAuthCapture' if tran_type == :capture_only
      tran_type = 'profileTransAuthCapture' if tran_type == :auth_and_capture
      xml  = '<createCustomerProfileTransactionRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
      xml += '<refId>' + order.tracking_number.to_s + '</refId>'
      xml += '<transaction><' + tran_type + '>'
      xml += '<amount>' + order.total.round(2).to_s + '</amount>'
      xml += '<tax><amount>' + order.tax.round(2).to_s + '</amount><name>NYC sales tax</name></tax>'
      xml += '<customerProfileId>' + self.customer.authdotnet_profile_id.to_s + '</customerProfileId><customerPaymentProfileId>' + self.payment_profile_id.to_s + '</customerPaymentProfileId>'
      xml += '<order><invoiceNumber>' + order.tracking_number.to_s + '</invoiceNumber><description>description of transaction</description></order>' if tran_type == 'profileTransAuthOnly'
      xml += '<taxExempt>false</taxExempt><recurringBilling>false</recurringBilling>' if tran_type == 'profileTransAuthOnly'
     # xml += '<cardCode>' + self.security_code.to_s + '</cardCode>' unless self.security_code.blank?
      xml += '<transId>' + order.payment.transaction_id.to_s + '</transId>' if tran_type == 'profileTransPriorAuthCapture'
      xml += '</' + tran_type + '></transaction>'
      xml += '</createCustomerProfileTransactionRequest>'
      
      @order = order
      response = self.send_to_authdotnet(xml)
      require 'rexml/document'
      dom = REXML::Document.new(response)
      dom.elements.each('createCustomerProfileTransactionResponse/messages/resultCode') do |element|
        #puts "Result Code = " + element.text.to_s
        @result = element.text.to_s
        if element.text.to_s == "Error"
          Notifier.deliver_auth_error(xml, response)
        end
      end
      dom.elements.each('createCustomerProfileTransactionResponse/messages/message/code') do |element|
        #puts "Result Message Code = " + element.text.to_s
        @result_code = element.text.to_s
      end
      dom.elements.each('createCustomerProfileTransactionResponse/messages/message/text') do |element|
        #puts "Result Message = " + element.text.to_s
        @message = element.text.to_s
      end
      dom.elements.each('createCustomerProfileTransactionResponse/directResponse') do |element|
        #puts element.text.to_s
        @response = self.interpret(element.text.to_s)
      end
      return true if @result == "Ok"
      return false
    else
      return true
    end
  end

  def deleteCustomerProfileTransactionRequest(order)
    tran_type = 'profileTransVoid'
    xml  = '<createCustomerProfileTransactionRequest xmlns="' + @@AUTHDOTNETAPINS + '">' + self.merchantAuthenticationXML
    xml += '<refId>' + order.tracking_number.to_s + '</refId>'
    xml += '<transaction><' + tran_type + '>'
    #xml += '<shipping><amount>' + order.shipping.round(2).to_s + '</amount></shipping>'
    xml += '<customerProfileId>' + self.customer.authdotnet_profile_id.to_s + '</customerProfileId><customerPaymentProfileId>' + self.payment_profile_id.to_s + '</customerPaymentProfileId>'
    xml += '<transId>' + order.payment.transaction_id.to_s + '</transId>'
    xml += '</' + tran_type + '></transaction>'
    xml += '</createCustomerProfileTransactionRequest>'
    
    @order = order
    response = self.send_to_authdotnet(xml)
    require 'rexml/document'
    dom = REXML::Document.new(response)
    dom.elements.each('createCustomerProfileTransactionResponse/messages/resultCode') do |element|
      #puts "Result Code = " + element.text.to_s
      @result = element.text.to_s
      if element.text.to_s == "Error"
        Notifier.deliver_auth_error(xml.to_s, response.to_s)
      end
    end
    dom.elements.each('createCustomerProfileTransactionResponse/messages/message/code') do |element|
      #puts "Result Message Code = " + element.text.to_s
      @result_code = element.text.to_s
    end
    dom.elements.each('createCustomerProfileTransactionResponse/messages/message/text') do |element|
      #puts "Result Message = " + element.text.to_s
      @message = element.text.to_s
    end
    dom.elements.each('createCustomerProfileTransactionResponse/directResponse') do |element|
      #puts element.text.to_s
      @response = self.interpret(element.text.to_s)
    end
    return true if @result == "Ok"
    return false
  end
  
  def interpret(response)
    puts "Interpreting transaction...", response, "======================"
    response_array = response.split(',')
    @response_code = response_array[0]
    response_subcode = response_array[1]
    response_reason_code = response_array[2]
    @response_reason_text = response_array[3]
    @approval_code = response_array[4]
    avs_response = response_array[5]
    @transaction_id = response_array[6]
    invoice_number = response_array[7]
    description = response_array[8]
    @amount_charged = response_array[9]
    method = response_array[10]
    @function = response_array[11]
    md5hash = response_array[37]
    
    puts ">>>>>>>>", @response_code, @response_reason_text, @transaction_id, @amount_charged, @function, self.response_code, "<<<<<<<<<"
    
    puts "The transaction id is " + @transaction_id.to_s
    
    if self.response_code == "approved" and @order
      #puts "I'm in 1"
      p = Payment.find_or_create_by_order_id(@order.id)
      p.amount = @amount_charged
      p.transaction_id = @function != 'void' ? @transaction_id : nil
      p.status = "authorized" if @function == 'auth_only'
      p.status = "complete" if @function == 'prior_auth_capture'
      (p.expiry = Date.today + 30.days) if @function == 'auth_only'
      p.expiry = nil if @function == 'prior_auth_capture'
      p.order_id = @order.id
      p.save!
      return true
    elsif @order
      #puts "I'm in 2"
      p = Payment.find_or_create_by_order_id(@order.id)
      p.amount = @amount_charged
      p.status = "unauthorized" unless p.status == 'authorized' || p.status == 'complete'
      p.save!
      errors.add_to_base(@response_reason_text)
      return false
    elsif self.response_code == "approved"
      #puts "I'm in 3"
      return true
    else
      #puts "I'm in 4"
      return false
    end
  end
  
  def after_find()
    puts "FINDING!"
    if self.payment_profile_id
      self.getCustomerPaymentProfileRequest
    end
    #self.getCustomerProfileRequest
  end
  
  def send_to_authdotnet(xml_data_string)
    require 'net/http'
    require 'net/https'
    require 'uri'
    
    url = URI.parse(@@AUTHDOTNET_GATEWAY)
    request = Net::HTTP::Post.new(url.path)
    
    logger.info "====REQUEST====\n"
    logger.info xml_data_string.to_s
    logger.info "================"
    
    request.body = xml_data_string
    request.content_type = 'text/xml'
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    
    response = http.start {|req| req.request(request)}
    
    case response
      when Net::HTTPSuccess, Net::HTTPRedirection
      logger.info "OK\n"
      logger.info "====RESPONSE===="
      logger.info response.to_s
      logger.info "================"
    else
      logger.info "ERROR\n"
      logger.info "================"
      res.error!
    end
    
    require 'rexml/document'
    
    @response = response.body
    logger.info @response
    @sent = true
    @response
  end
end
