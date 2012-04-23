# == Schema Information
# Schema version: 98
#
# Table name: employees
#
#  id            :integer(11)   not null, primary key
#  referral_code :string(255)   
#  home          :string(10)    
#  cell          :string(10)    
#

class Employee < ActiveRecord::Base
  has_one :user, :as => :account
  has_many :addresses, :dependent => :destroy
  validates_associated :user
  validates_presence_of :addresses, :home, :cell
  validates_numericality_of :home, :only_integer => true
  validates_numericality_of :cell, :only_integer => true
  validates_length_of       :home,    :is => 10
  validates_length_of       :cell,    :is => 10
  has_many :employee_payouts, :as => :payments
  
  def account
    self.user
  end
  def account=(a)
    self.user = a
  end
  
  def before_save
    if self.referral_code == nil
      self.referral_code = self.account.first_name.upcase + self.account.id.to_s
    end
  end
  
  def referred_customers
    #returns the customers this employee referred
    User.find_all_by_account_type_and_referrer("Customer", self.account).collect{ |u| u.account }
  end
  
  def referred_customer_activity(start, end_)
    self.referred_customers.collect { |c| c.payment_activity('complete') }.collect{ |c| c.amount }.flatten
  end
  
  def balance
    #this is computationally very expensive.  Need to make this more efficient
    self.referred_customer_activity.sum - self.total_paid_out
  end
  
  def total_paid_out
    EmployeePayOut.find_all_by_employee_id(self).collect{ |e| e.amount }.sum
  end
  
end
