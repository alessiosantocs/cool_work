class Schedule
  attr_reader :date, :location
  
  def initialize(loc, day = Date.today())
    @location = loc
    @date = day
    @stops = []
  end
  
  def copy_forward
    self.copy_to(self.date + 1.day)
  end
  
  def copy_backward
    self.copy_to(self.date - 1.day)
  end
  
  def copy_to_next_week
    self.copy_to(self.date + 7.days)
  end
  
  def copy_to(date)
    self.stops.each do |stop|
      if stop
        new_stop       = Stop.find_or_create_by_date_and_window_id_and_location_id(date, stop.window_id, stop.location_id)
        new_stop.slots = stop.slots
        new_stop.save!
      end
    end
    Schedule.for(@location, date)
  end
  
  def copy_to_locations(date, locations)
    self.stops.each do |stop|
      if stop
        locations.each do |location|
          new_stop       = Stop.find_or_create_by_date_and_window_id_and_location_id(date, stop.window_id, location.id)
          new_stop.slots = stop.slots
          new_stop.save!
        end
      end
    end
    Schedule.for(@location, date)
  end
  
  def self.for(loc, day = Date.today(), start_time = nil)
    loc = loc.location if loc
    sched = Schedule.new(loc, day)
    wins = Window.find_all_regular
    stops = Stop.find(:all, :conditions => ['date = ? AND location_id = ?', day, loc])
    wins.each_with_index do |w,i|
      found = false
      stops.each do |s|
        if s.window_id == w.id
          if start_time != nil && start_time.to_i > w.start.hour
            sched.stops[i] = nil
          else
            sched.stops[i] = s
          end
          found = true
          break
        end
      end
      if found == false
        #sched.stops[i] = nil  
        sched.stops[i] = Stop.create(:location => loc.location, :date => day, :window => w)
      end
      found = false
    end
    sched
  end
  
  def self.for_week_of(loc, start_day = Date.today(), start_time = nil)
    week = []
    week << Schedule.for(loc.location, start_day, start_time)
     (1..7).each do |i|
      week << Schedule.for(loc.location, start_day + i.days)
    end
    week
  end
  
  def stops
    @stops
  end
  
  def stops= (val)
    self.update_attribute(val)
  end
  
  def to_s(format = "%a %m/%y")
    @date.strftime(format)
  end
  
  def [] (window)
    @stops[window]
  end
  def []= (idx, val)
    @stops[idx]=val
  end
  
  def wday
    @date.wday
  end
  
  def day_of_week(short_or_long = :short)
    if short_or_long == :short
      ["S", "M", "T", "W", "Th", "F", "Sa"][self.wday] 
    else 
      ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][self.wday]
    end
  end
  
  def errors?
    errors = false
    @stops.each do |s|
      if s.class == Stop && s.error?
        errors = true
        break
      end
    end
    errors
  end
  
  def total_slots
    total = 0
    @stops.each do |s|
      if s.class == Stop
        total += s.slots.to_i
      end
    end
    total
  end
  
  def total_requests
    total = 0
    @stops.each do |s|
      if s.class == Stop
        total += s.request_count
      end
    end
    total
  end
  
  def slots_available
    self.total_slots - self.total_requests + self.total_concordance
  end
  
  def total_concordance
    total = 0
    @stops.each do |s|
      if s.class == Stop
        total += s.concordant_request_count
      end
    end
    total
  end
  
  def heat
    if total_slots == 0 
      0
    else
     (1.0 * total_requests) / total_slots
    end
  end
  
  def editable?
    true
  end
end