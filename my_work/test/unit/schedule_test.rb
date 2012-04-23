require File.dirname(__FILE__) + '/../test_helper'
require 'db/migrate/populate_regular_windows'

class ScheduleTest < ActiveSupport::TestCase
  #fixtures :windows
  
  def test_general_func
    (8..18).each do |i|
      s = Stop.new(:slots => 0, 
                   :date => Date.today() + 7.days, 
                   :complete => false, 
                   :location_id => ServicedZip.find_by_zip('10005').location.id,
                   :window_id => Window.find(:first, :conditions => ["start = ?", Time.local(0) + i.hours]).id
                   )
      s.save!
    end
    
    sched1 = Schedule.for(ServicedZip.find_by_zip('10005'), Date.today() + 7.days)
    assert sched1[0] == nil
    assert sched1[9] != nil
    sched1[9].slots = 10
    pp sched1.total_slots
    assert sched1.total_slots == 10
    sched1[10].slots = 3
    assert sched1.total_slots == 13
    assert sched1.total_requests == 0
    assert sched1.total_concordance == 0
    puts sched1
    assert sched1.slots_available == 13
  end
end



#old shift test
# require File.dirname(__FILE__) + '/../test_helper'
# 
# class ShiftTest < ActiveSupport::TestCase
#   
#   def test_same_day_as_function
#     midnight = Time.local(0)
#     friday_recurring_shift = Shift.new(:recurring => true, :day_of_week => "Friday")
#     different_friday_nonrecurring_shift = Shift.new(:recurring => false, :day => Date.new(2007,12,28))
#     friday_nonrecurring_shift = Shift.new(:recurring => false, :day => Date.new(2007,12,21))
#     saturday_recurring_shift = Shift.new(:recurring => true, :day_of_week => "Saturday")
#     saturday_nonrecurring_shift = Shift.new(:recurring => false, :day => Date.new(2007,12,29))
# 
#     assert defined? friday_recurring_shift
#     assert defined? different_friday_nonrecurring_shift
#     assert defined? friday_nonrecurring_shift
#     assert defined? saturday_recurring_shift
#     assert defined? saturday_nonrecurring_shift
#     assert friday_recurring_shift.same_day_as(friday_nonrecurring_shift)
#     assert friday_recurring_shift.same_day_as(different_friday_nonrecurring_shift)
#     assert !friday_nonrecurring_shift.same_day_as(different_friday_nonrecurring_shift)
#     assert !friday_recurring_shift.same_day_as(saturday_recurring_shift)
#     assert !friday_recurring_shift.same_day_as(saturday_nonrecurring_shift)
#   end
#   
#   def test_overlap_function
#     midnight = Time.local(0)
#     today = Time.today
#     main_shift = Shift.new(:start => midnight, :end => midnight + 2.hours, :recurring => true, :regular => true, :day_of_week => "Friday")
#     nonoverlapping_shift = Shift.new(:start=> midnight + 2.hours + 1.second, :end => midnight + 4.hours, :recurring => true, :regular => true, :day_of_week => "Friday")
#     overlapping_shift = Shift.new(:start=>midnight + 1.hour, :end => midnight + 3.hours, :recurring => true, :regular => true, :day_of_week => "Friday")
#     encapsulated_shift = Shift.new(:start=>midnight + 10.minutes, :end => midnight + 2.hours - 10.minutes, :recurring => true, :regular => true, :day_of_week => "Friday")
#     
#     assert main_shift.overlaps(overlapping_shift)
#     assert !main_shift.overlaps(nonoverlapping_shift)
#     assert main_shift.overlaps(encapsulated_shift)
#     assert overlapping_shift.overlaps(main_shift)
#     assert !nonoverlapping_shift.overlaps(main_shift)
#     assert encapsulated_shift.overlaps(main_shift)
#     
#     tue_6_8_shift = Shift.new(:start => today + 6.hours, :end => today + 8.hours - 1.second, :day_of_week => "Tuesday", :recurring => true, :regular => true)
#     tue_6_8_shift.save!
#     
#     wed_6_8_shift = Shift.new(:start => today + 6.hours, :end => today + 8.hours - 1.second, :day_of_week => "Wednesday", :recurring => true, :regular => true)
#     wed_6_8_shift.save!
#     
#     tue_7_9_shift = Shift.new(:start => today + 7.hours, :end => today + 9.hours - 1.second, :day_of_week => "Tuesday", :recurring => true, :regular => true)
#     tue_7_9_shift.save!
#     
#     assert tue_6_8_shift.overlaps(tue_7_9_shift)
#     assert tue_7_9_shift.overlaps(tue_6_8_shift)
#     assert !tue_6_8_shift.overlaps(wed_6_8_shift)
#   end
#   
#   def test_weekday_and_weekend_function
#     midnight = Time.local(0)
#     friday_recurring_shift = Shift.new(:start => midnight, :end => midnight + 2.hours, :recurring => true, :regular => true, :day_of_week => "Friday")
#     saturday_recurring_shift = Shift.new(:start => midnight, :end => midnight + 2.hours, :recurring => true, :regular => true, :day_of_week => "Saturday")
#     friday_nonrecurring_shift = Shift.new(:recurring => false, :day => Date.new(2007,12,28))
#     saturday_nonrecurring_shift = Shift.new(:recurring => false, :day => Date.new(2007,12,29))
#     
#     assert friday_recurring_shift.weekday?
#     assert saturday_recurring_shift.weekend?
#     assert !friday_nonrecurring_shift.weekend?
#     assert !saturday_nonrecurring_shift.weekday?
#   end
# end
