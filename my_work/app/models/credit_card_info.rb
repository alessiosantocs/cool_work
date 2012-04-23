class CreditCardInfo < ActiveRecord::Base
  belongs_to :order 
end
