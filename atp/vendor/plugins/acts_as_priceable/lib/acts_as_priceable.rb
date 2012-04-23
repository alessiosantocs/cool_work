module ActiveRecord
  module Acts #:nodoc:
    module Priceable #:nodoc:
        # Extends your class with acts_as_priceable method
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_priceable(options = {})
          write_inheritable_attribute(:acts_as_priceable_options, {
            :priceable_type => ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s,
            :from => options[:from] # usused currently, could be used for using other table/class than prices
          })
          
          class_inheritable_reader :acts_as_priceable_options

          has_many :currencies, :through => :prices # Link to currencies table
          has_many :pricings, :as => :priceable, :dependent => :destroy
          has_many :prices, :through => :pricings do # Link to prices table
            
              # Updates price record if record exists
              # Creates price record if record does not exists
            def update_or_create_price(new_price)
              # Find the price to update if it exists
              existing_price = self.find_by_currency_id(new_price.currency_id)
              
              if existing_price.is_a? Price # price exists for currency? Update it
                existing_price.amount = new_price.amount
                existing_price.save #*** SHOULD THIS BE DONE ELSEWHERE? WITH this object's save()? ***
              else # Create price
                Price.create(new_price).on(@owner) # Hackish.. self << new_price doesn't seem to work properly
              end
            end
            
              # Set price, takes:
              # - Integer: Uses Pricing.default_currency
              # - Hash: With options :currency_id and :price
              # - Price object
            def price=(new_price)
              new_price = Price.new(new_price)

              raise 'Negative price!' if ((new_price.amount) and (new_price.amount < 0))

              self.update_or_create_price(new_price)
            end
            
              # Get a price for a particular currency
            def price(currency = Pricing.default_currency)
              currency = Currency[currency] unless currency.is_a? Currency
              
              self.find(:first, :conditions => ['currency_id = ?', currency.id])
            end
          end
          
            # Shortcuts, allow calling of self.price instead of self.prices.price
          delegate :price=, :to => :prices
          delegate :price,  :to => :prices
          
          extend ActiveRecord::Acts::Priceable::SingletonMethods
        end
      end
      
      module SingletonMethods
          # This allows you to scope a find, create, update, etc. for to a particular currency. e.g.
          #   # Returns all products that have an associated GBP price
          # Product.with_currency_scope(Currency[:gbp])
          #   Product.find(:all)
          # end
          #
          # If no currency is passed in, default currency is assumed
        def with_currency_scope(currency = Pricing.default_currency, &block)
          self.with_scope(:find => {:include => :prices, :conditions => ['prices.currency_id = ?', currency.id]},
                          :create => {:currency => currency}) do
            yield
          end
        end
      end
    end
  end
end