# == Schema Information
# Schema version: 98
#
# Table name: payments
#
#  id             :integer(11)   not null, primary key
#  amount         :decimal(8, 2) 
#  transaction_id :string(255)   
#  status         :string(255)   
#  expiry         :datetime      
#  order_id       :integer(11)   
#  created_at     :datetime      
#  updated_at     :datetime      
#  credit_card_id :integer(11)   
#

class Payment < ActiveRecord::Base
  belongs_to :order
  belongs_to :credit_card
  
  @@StatusMenu = ['authorized', 'complete', 'declined']
  
  def paid?
    if self.status == 'complete'
      return true
    end
    return false
  end
  
  def delinquent?
    if self.status == 'declined'
      return true
    end
    return false
  end
  
  def authorized?
    if self.status == 'authorized'
      return true
    end
    return false
  end
  
  def charge!
    result = self.credit_card.capture(self.order)
    unless result
      errors.add_to_base(self.credit_card.response_reason_text)
    end
  end
  
  def capture
    self.charge!
  end
  
  def authorize
    result = self.credit_card.authorize(self.order)
    unless result
      errors.add_to_base(self.credit_card.response_reason_text)
    end
  end
  
  def self.StatusMenu
    @@StatusMenu
  end
  
  def cc_payment_method
    self.credit_card.payment_method if self.credit_card
  end
  
  def cc_number
    self.credit_card.number if self.credit_card
  end
  
  def cc_expiration
    self.credit_card.expiration if self.credit_card
  end
  
  def cc_security_code
    ""
  end
  
  def cc_address
    self.credit_card.address if self.credit_card
  end
  
  def cc_city
    self.credit_card.city if self.credit_card
  end
  
  def cc_zip
    self.credit_card.zip if self.credit_card
  end
  def cc_state
    self.credit_card.state if self.credit_card
  end
end
