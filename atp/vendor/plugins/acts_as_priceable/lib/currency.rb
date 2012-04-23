# Heavily influenced by the enumerations mixin by Trevor Squires
class Currency < ActiveRecord::Base
  validates_presence_of   :code
  validates_uniqueness_of :code
  validates_length_of :code, :is => 3
  
  def self.all
    return @all if @all
    @all = find(:all).collect{|val| val.freeze}.freeze
  end
  
  def self.[](arg)
    case arg
    when Symbol
      rval = lookup_code(arg.id2name) and return rval
    when String
      rval = lookup_code(arg) and return rval
    when Fixnum
      rval = lookup_id(arg) and return rval
    when nil
      rval = nil 
    else
      raise TypeError, "#{self.name}[]: argument should be a String, Symbol or Fixnum but got a: #{arg.class.name}"            
    end
  end
  
  def self.lookup_id(arg)
    all_by_id[arg]
  end

    # Assumes all codes are uppercase (GBP, USD, etc.)
  def self.lookup_code(arg)
    all_by_code[arg.upcase]
  end
  
    # Converts a currency code to a currency id by doing a database lookup
  def self.code_to_id(currency_code)
    currency = self[currency_code]
    return currency.id unless currency.nil?
    nil
  end
  
  private
  
  def self.all_by_code
    return @all_by_code if @all_by_code
    @all_by_code = all.inject({}) { |memo, item| memo[item.code] = item; memo;}.freeze              
  end
  
  def self.all_by_id
    return @all_by_id if @all_by_id
    @all_by_id = all.inject({}) { |memo, item| memo[item.id] = item; memo;}.freeze
  end
end