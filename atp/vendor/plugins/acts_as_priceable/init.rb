require 'acts_as_priceable'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Priceable)

require File.dirname(__FILE__) + '/lib/pricing'
require File.dirname(__FILE__) + '/lib/price'
require File.dirname(__FILE__) + '/lib/currency'