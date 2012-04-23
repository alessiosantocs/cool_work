require File.dirname(__FILE__) + '/../test_helper'

class DriverTest < ActiveSupport::TestCase
  def test_is_available_for_shift
    today = Time.today
    
    tue_6_8_shift = Shift.new(:start => today + 6.hours, :end => today + 8.hours - 1.second, :day_of_week => "Tuesday", :recurring => true, :regular => true)
    tue_6_8_shift.save!
    
    wed_6_8_shift = Shift.new(:start => today + 6.hours, :end => today + 8.hours - 1.second, :day_of_week => "Wednesday", :recurring => true, :regular => true)
    wed_6_8_shift.save!
    
    tue_7_9_shift = Shift.new(:start => today + 7.hours, :end => today + 9.hours - 1.second, :day_of_week => "Tuesday", :recurring => true, :regular => true)
    tue_7_9_shift.save!
    
    driver = Driver.new(:user => {:first_name => "John", :last_name => "McDriver", :login => "jmcdriver", :password => "bully!", :password_confirmation => "bully!", :email => "jmcdriver@email.com", :maiden => "O'Driver"})
    driver.save!
    
    assignment = Assignment.new(:driver => driver, :shift => tue_6_8_shift)
    assignment.save!
    
    assert tue_6_8_shift.same_day_as(tue_7_9_shift)
    assert tue_6_8_shift.overlaps(tue_7_9_shift)
    assert driver.is_available_for(wed_6_8_shift)
    assert !driver.is_available_for(tue_7_9_shift)
  end
end
