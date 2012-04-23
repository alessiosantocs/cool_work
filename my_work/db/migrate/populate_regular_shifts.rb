# day_array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
# day_array.each do |day_of_week|
#   midnight = Time.local(0)
#   i = 0
#   interval = 2
#   until i == 24
#     s = Shift.new(:start => midnight + i.hours, :recurring => true, :regular => true, :end => midnight + i.hours + interval.hours - 1.seconds, :day_of_week => day_of_week)
#     i = i + interval
#     s.save!
#   end
# end

midnight = Time.local(0)

  [6,8,10,12,14,16,18,20].each do |h|
    s = Shift.new(:start => midnight + h.hours, :recurring => false, :regular => true, :end => midnight + (h+2).hours - 1.second)
    s.save!
  end