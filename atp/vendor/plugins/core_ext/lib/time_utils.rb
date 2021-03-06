module TimeUtils
  def db
    self.strftime("%Y-%m-%d %I:%M:%S%p")
  end
  
  def db_with_slashes
    self.strftime("%Y/%m/%d %I:%M:%S%p")
  end
  
  def month_day
    "#{self.strftime('%b')} #{self.day}"
  end
  
  def hr_min
    self.strftime("%I:%M%p").sub(/^0/,'')
  end
  
  def short_date
    self.strftime(self.year == Time.now.year ? "%a, %b %d" : "%a, %b %d %y")
  end
  
  def short_date_and_time
    "#{self.short_date} #{self.hr_min}"
  end
  
  def w3c
    self.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
end

class Time
  include TimeUtils
  
  def to_datetime
    DateTime.civil(year, mon, day, hour, min, sec)
  end
end

class DateTime
  include TimeUtils
  
  def to_time
    Time.mktime(year, mon, day, hour, min, sec)
  end
end

class Date
  def month_day(separator="/")
    d = [self.mon, self.mday]
    d << self.year unless self.year == Time.now.year
    d.join(separator)
  end
end