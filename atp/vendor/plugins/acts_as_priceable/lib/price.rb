class Price < ActiveRecord::Base
  include Comparable
  
  belongs_to :currency
  has_many :pricings
  
  validates_numericality_of :amount
  validates_presence_of :amount
  validates_presence_of :currency
  
    # used in Price#to_s
  include ActionView::Helpers::NumberHelper
  
  def self.new(*values)
    values = self.produce_hash_from_params(values)
    super(values)
  end
  
  def self.create(*values)
    values = self.produce_hash_from_params(values)
    super(values)
  end
  
    # Amount is stored as an integer (e.g. cents/pence)
    # Returns nil if amount is set to nil (should this ever happen?)
  def amount
    read_attribute(:amount) / 100.to_f if read_attribute(:amount)
  end
  
    # Amount is stored as an integer (e.g. cents/pence)
  def amount=(amount)
    write_attribute(:amount, amount ? (amount*100).round : nil)  # Some very strange rounding errors happen if
  end                                                            # .round isn't used: (0.29 * 100).to_i => 28 !?!?
  
    # Price any priceable with self
  def on(priceable)
    pricings.create :priceable => priceable
  end
  
    # Returns text version of price
  def to_s
    return number_to_currency(self.amount, {:unit => Pricing.default_currency.symbol, :separator => '.', :deliminator => ','}) if self.currency.nil?
    return number_to_currency(self.amount, {:unit => self.currency.symbol, :separator => '.', :deliminator => ','})
  end
  
  def to_f
    self.amount
  end
  
    # Use cached currency table, this should be implicit but currently have to force it
  def currency
    Currency[self.currency_id]
  end
  
    # Currently only support arithmetic operations on prices of the same currency
  def +(price) arithmetic_operation(price) { |a,b| a + b } end
  def -(price) arithmetic_operation(price) { |a,b| a - b } end
  def *(price) arithmetic_operation(price) { |a,b| a * b } end
  def /(price) arithmetic_operation(price) { |a,b| a / b } end

    # Compare prices
  def <=>(price)
    price = Price.produce_price_from_params(price)
    check_currency_mismatch(price)
    
    self.amount <=> price.amount
  end
  
  private
  
    # Currently only support arithmetic operations on prices of the same currency
  def arithmetic_operation(price)
    price = Price.produce_price_from_params(price)
    check_currency_mismatch(price)
    
    Price.new(:amount => yield(self.amount, price.amount), :currency => price.currency)
  end
  
  def check_currency_mismatch(price)
    unless ((self.currency == price.currency) or self.currency.nil? or price.currency.nil?)
      raise 'Currency of the prices being manipulated or compared don\'t match!' 
    end
  end

  
  def self.produce_price_from_params(values)
    values = values.first if values.is_a? Array
    
    price = case values
      when String, Fixnum, Float, NilClass : 
        self.new( :amount => self.produce_float_from_amount_param(values) )
      when Hash: self.new(values)
      when Price: values
    end
    
    price
  end
  
  def self.produce_hash_from_params(values)
    values = values.first if values.is_a? Array
    
    hash = case values
      when String, Fixnum, Float, NilClass : {:amount => self.produce_float_from_amount_param(values)}
      when Hash : values
      when Price : { :amount => values.amount, :currency => values.currency }
    end
    
    hash[:currency] = Currency[hash[:currency]] if hash[:currency].is_a? Symbol
    hash[:currency] = Pricing.default_currency if hash[:currency].nil?
    hash[:currency] = nil if hash[:currency] == false # use of currency has been disabled
    hash
  end
  
  def self.produce_float_from_amount_param(param)
    return case param
      when String   : param.to_f
      when Fixnum   : param.to_f
      when Float    : param
      when NilClass : 0.00
    end
  end
end