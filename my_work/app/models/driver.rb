# == Schema Information
# Schema version: 98
#
# Table name: drivers
#
#  id      :integer(11)   not null, primary key
#  user_id :integer(11)   
#

class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :assigments
  
  def is_available_for(shift)
    shifts = Assignment.find_all_shifts_by_driver(self.id)
    shifts.each do |s|
      pp "comparing", shift, "to", s, shift.overlaps(s), "========"
      return false if shift.overlaps(s)
    end
    true
  end
  
  def account
    self.user
  end
  
  def name
    self.user.name  
  end
  
  def account= val
    self.user = val
  end
end

#params = {:info => "info field", :user => {:login => "someuser", :password => "somepassword"}}


#cust# + zip + 8 digit autoincrementing 
