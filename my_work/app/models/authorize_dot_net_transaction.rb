class AuthorizeDotNetTransaction
  def initialize()
    @x_version = '3.1'
    @x_delim_data = 'TRUE'
    @x_delim_char = '|'
    @x_encap_char = ''
  end
  
  attr_accessor(:x_login, :x_type, :x_amount, :x_card_num, :x_exp_date, :x_card_code, :x_invoice_num, :x_trans_id, :x_tran_key, :response, :message)
  
  def authorize(order, cc, force = false)
    #PERFORM AUTH TRANSACTION
    if force == true or (order.payment and ['unauthorized', nil].index(order.payment.status) and force == false)
      @order = order
      @x_type = 'AUTH_ONLY'
      @x_amount = order.amount.to_s
      @x_card_num = cc.number.to_s
      @x_exp_date = cc.expiration.to_s
      @x_card_code = cc.security_code.to_s
      @x_invoice_num = order.id.to_s
      @x_first_name = cc.first_name
      @x_last_name = cc.last_name
      @x_address = cc.address
      @x_city = cc.city
      @x_state = cc.state
      @x_zip = cc.zip
      self.send()
    else
      raise Exception, "payment authorization transaction already processed for this order, set force = true or use reauthorize method"
    end
  end
  
  def reauthorize(order, cc)
    self.authorize(order, cc, force = true)
  end
  
  def successful?
    return nil unless @sent
    if self.response_code == 'approved'
      return true
    else
      return false
    end
  end
  
  def finalize(order, cc)
    #SETTLE PREVIOUS TRANSACTION
    if order.payment.status == "authorized" && Date.now <= order.payment.expiry
      @x_type = 'PRIOR_AUTH_CAPTURE'
      @x_trans_id = order.payment.transaction_id
      @x_amount = order.amount.to_s #this must be <= amount @ time of @authorize
    else
      #we need to figure out what to do if more than 30 days have elapsed since the credit card authorization.
      #by law, we cannot charge (finalize) the transaction until the goods have been delivered.
      raise Exception, "No payment authorization on record"
    end
  end
  
  def verifyCA(ca_file, http) #need to assemble a ca_file
    if File.exist? ca_file
      http.ca_file = ca_file
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5
      return http
    else
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      return http
    end
  end
  
  def send()
    require 'net/http'
    require 'net/https'
    require 'uri'
    if ENV['RAILS_ENV'] == 'development'
      @x_login = '34Smwrc5pTq'
      @x_tran_key = '3g7W5Pq27N4s7wzL'
      @x_test_request = 'TRUE'
      #url = URI.parse("https://test.authorize.net/gateway/transact.dll")
      url = URI.parse("https://secure.authorize.net/gateway/transact.dll")
    elsif ENV['RAILS_ENV'] == 'testing'
      @x_login = '6zz6m5N4Et'
      @x_tran_key = '9V9wUv6Yd92t27t5'
      @x_test_request = 'TRUE'
      url = URI.parse("https://test.authorize.net/gateway/transact.dll")
    elsif ENV['RAILS_ENV'] == 'production'
      @x_login = '34Smwrc5pTq'
      @x_tran_key = '3g7W5Pq27N4s7wzL'
      @x_test_request = 'FALSE' # CHANGE THIS TO FALSE WHEN WE GO LIVE!!!
      url = URI.parse("https://secure.authorize.net/gateway/transact.dll")
    end
    
    request = Net::HTTP::Post.new(url.path)
    
    request.set_form_data({
      'x_type' => @x_type,
      'x_amount' => @x_amount,
      'x_card_num' => @x_card_num,
      'x_exp_date' => @x_exp_date,
      'x_card_code' => @x_card_code,
      'x_invoice_num' => @x_invoice_num,
      'x_login' => @x_login,
      'x_tran_key' => @x_tran_key,
      'x_test_request' => @x_test_request,
      'x_delim_data' => @x_delim_data,
      'x_delim_char' => @x_delim_char,
      'x_encap_char' => @x_encap_char,
      'x_version' => @x_version,
      'x_first_name' => @x_first_name,
      'x_last_name' => @x_last_name,
      'x_address' => @x_address,
      'x_city' => @x_city,
      'x_state' => @x_state,
      'x_zip' => @x_zip,
    })
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    
    #response = Net::HTTP.new(url.host, url.port).start {|req| req.request(http) }
    response = http.start {|req| req.request(request)}
    
    case response
      when Net::HTTPSuccess, Net::HTTPRedirection
      #puts "OK\n"
      #puts response
    else
      res.error!
    end
    
    @response = response.body
    #puts @response
    self.interpret
    @sent = true
  end
  
  def interpret
    response = @response
    response_array = response.split('|')
    @response_code = response_array[0]
    response_subcode = response_array[1]
    response_reason_code = response_array[2]
    @response_reason_text = response_array[3]
    approval_code = response_array[4]
    avs_response = response_array[5]
    @transaction_id = response_array[6]
    invoice_number = response_array[7]
    description = response_array[8]
    @amount_charged = response_array[9]
    method = response_array[10]
    md5hash = response_array[37]
    
    #puts "The transaction id is ", @transaction_id
    
    if self.response_code == "approved"
      p = Payment.find_or_create_by_order_id(@order.id)
      p.amount = @amount_charged
      p.transaction_id = @transaction_id
      p.status = "authorized"
      p.expiry = Date.today + 30.days
      p.order_id = @order.id
      p.save!
    else
      p = Payment.find_or_create_by_order_id(@order.id)
      p.amount = @amount_charged
      p.status = "unauthorized"
      p.save!
    end
  end
  
  def response_code(as_string = true)
    if as_string
      return [nil, "approved", "declined", "error", "held for review"][@response_code.to_i]
    else
      return @response_code
    end
  end
  
  def message
    return @response_reason_text
  end
end

# o = Order.new
#  o.amount = 0.01
#  o.id = 5
#  cc = CreditCard.new
#  cc.initialize_params('377240174501004', '1111', '9061', 'John', 'Doe', '123 Sesame St', 'New York', 'NY', '10015')
#  t = AuthorizeDotNetTransaction.new
#  t.reauthorize(o,cc)
#  
#  puts t.response_code
#  puts t.message