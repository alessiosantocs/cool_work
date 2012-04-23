class Pricing < ActiveRecord::Base
  belongs_to :price
  belongs_to :priceable, :polymorphic => true
  
    # Returns default currency
  def self.default_currency
    return @@default_currency_cache if @@default_currency_cache
    @@default_currency_cache = Currency[@@default_currency]
  end
  
    # Set the default currency, use this to set default currency app-wide
    # e.g. Pricing.default_currency = 'USD'
    # Good place to put this might be at the end of your environment.rb ?
  def self.default_currency=(currency)
    @@default_currency = currency
      # We don't cache it now to avoid loading errors when database doesn't exist yet, e.g. in migration
    @@default_currency_cache = nil if @@default_currency_cache
  end
  
  protected
    # This can be overriden with e.g. Pricing.default_currency = 'Currency[:GBP]
  @@default_currency_cache = nil
  @@default_currency = :gbp
end