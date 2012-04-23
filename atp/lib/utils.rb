module Utils
  def time_string(date)
    date.strftime("%I:%M%p")
  end

  def date_string(date)
    if date.year == Time.now.year
      date.strftime("%a, %b %d")
    else
      date.strftime("%a, %b %d %y")
    end
  end
  
  def ajax_response(text, good=false, content_type="text/javascript")
    headers["Content-Type"] = "#{content_type}; charset=utf-8" 
    if good==false
      render :inline => text, :status => "400 Bad Request"
    else
      render :inline => text, :status =>"200 Ok"
    end
  end
  
  def log(msg)
    RAILS_DEFAULT_LOGGER.debug  "### #{msg}"
  end
  
	def valid_email?(email)
		email.size < 100 && email =~ /.@.+\../ && email.count('@') == 1
	end
  
  def parse_time(date_time)
    d = Time.parse date_time.to_s
    DateTime.new(d.year, d.mon, d.day, d.hour, d.min)
  end

	def generate_challenge( len=32, extra=[] )
		len = 32 if len > 32
	    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + extra # + ['#','.','%','@','*','_']
	    str = ""
	    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
	    str
	end
	
	def clear_cookies(c)
	  cookies[c] = { :value => nil, :domain => ".#{request.domain}", :path => '/', :expires => Time.at(-1000) }
	end
	
	def city_ids(region_id)
    city_ids = []
    CITIES.find_all{ |v,k|  v[:region_id]==region_id }.each { |c| city_ids << c[:id] }
    city_ids
  end
end

module TimeUtils
  def db
    self.strftime("%Y-%m-%d %I:%M:%S%p")
  end
  
  def month_day
    self.strftime("%b %d")
  end
  
  def hr_min
    self.strftime("%I:%M%p")
  end
  
  def short_date
    self.strftime(self.year == Time.now.year ? "%a, %b %d" : "%a, %b %d %y")
  end
  
  def w3c
    self.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
  
  # options
  # :start_date, sets the time to measure against, defaults to now
  # :date_format, used with <tt>to_formatted_s<tt>, default to :default
  def time_ago(options={})
    start_date = options.delete(:start_date) || Time.new
    date_format = options.delete(:date_format) || :default
    delta_minutes = (start_date.to_i-self.to_i).floor / 60
    if delta_minutes.abs <= (8724*60) # eight weeks… I’m lazy to count days for longer than that
      distance = distance_of_time_in_words(delta_minutes);
      if delta_minutes < 0
        "#{distance} from now"
      else
        "#{distance} ago"
      end
    else
      return "on #{self.short_date}"
    end
  end

  def distance_of_time_in_words(minutes)
    case
      when minutes < 1
        "less than a minute"
      when minutes < 50
        "#{minutes} minutes"
      when minutes < 90
        "about one hour"
      when minutes < 1080
        "#{(minutes / 60).round} hours"
      when minutes < 1440
        "one day"
      when minutes < 2880
        "about one day"
      else
        "#{(minutes / 1440).round} days"
    end
  end
end

class Time
  include TimeUtils
end

class DateTime
  include TimeUtils
end

class String
  def escape_quotes
    self.gsub(/("|')/, '\\\\\1')
  end
  
  def add_slashes
    self.gsub(/\//, '\\\\\'')
  end

  def strip_slashes
    self.gsub(/\\/, '')
  end
  
  def maxlength(count, suffix="... ")
    self.length > count ? self.first(count) + suffix : self
  end
  
  def initial_caps
    self.gsub(/\b\w/) { $&.upcase }
  end
end