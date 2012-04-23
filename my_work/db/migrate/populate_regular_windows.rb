midnight = Time.local(0)

if Window.find(:all, :conditions => ['regular = ?', true]) == []
  (0..23).each do |h|
    w = Window.new(:start => midnight + h.hours, 
                   :end => midnight + h.hours + 59.minutes + 59.seconds,
                   :regular => true)
    w.save
  end
end