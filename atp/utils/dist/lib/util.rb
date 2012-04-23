module Util
  def initial_caps(name)
  	name.to_s.split.collect { |x| x.capitalize }.join(' ')
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
  
  def get_region_and_site
    @site = Site.find_by_url(params[:domain])
    @region = @site.regions.find_by_short_name(params[:region])
  end
  
	def validate_user
	  @user = User.find(:first, :select => ['id, username, member_login_key'],  :conditions => ["id=?", cookies[:current_user].split(';').last])
	  @user = nil unless @user.member_login_key == cookies[:upload_id]
	end

  def get_site
    @site = Site.find_by_url(domain)
  end
end