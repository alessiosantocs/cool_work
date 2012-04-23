module Utils
  def time_string(date)
    date.strftime("%I:%M%p").sub(/^0/,'')
  end

  def date_string(date)
    f = "%a, %b %d"
    unless date.year == Time.now.year
      f << " %y"
    end
    date.strftime f
  end
  
  def good_response(msg='')
    ajax_response msg, :state => true
  end
  
  def bad_response(msg='')
    ajax_response msg
  end
  
  def ajax_response(text,options={}) 
    opt = {
      :content_type => "text/javascript",
      :state => false
    }.merge(options)
    
    headers["Content-Type"] = "#{opt[:content_type]}; charset=utf-8" 
    
    render :inline => text.to_s, :status => ( opt[:state] === false ? :bad_request : :ok )
  end
  
  def log(msg)
    RAILS_DEFAULT_LOGGER.debug  "### #{msg}"
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
	
  def ping_a_url(url)
    `curl -s0 #{url}`
  end
  
	def clear_cookies(c)
	  cookies[c] = { :value => nil, :domain => ".#{request.domain}", :path => '/', :expires => Time.at(-1000) }
	end
	
  def retryable(options = {}, &block)
    opts = { :tries => 1, :on => Exception }.merge(options)
    retry_exception, retries = opts[:on], opts[:tries]
    begin
      return yield
    rescue retry_exception
      retry if (retries -= 1) > 0
    end
    yield
  end
  
	#creates javascript_include and stylesheet_include
  def asset_include(assets=["js", "css"])
    assets.each do |el|
      case el
        when "js"
          tag = "javascript_include_tag"
        when "css"
          tag = "stylesheet_link_tag"
        else
          raise "Bad Asset Type. Must be CSS or JS."
      end
      eval <<-EOL
      def #{el}_include(files)
        return if files.nil?
        buffer = []
        files.each do |f|
          buffer << #{tag}(f)
        end
        buffer.join("\n")
      end
      EOL
    end
  end
end