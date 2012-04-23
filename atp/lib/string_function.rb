module StringFunction
  def generate_challenge( len=32 )
    len = 32 if len > 32
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a# + ['#','.','%','@','*','_']
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    str
  end
  
  def makesafe(str)
		str = str.gsub(/&lt;/, "<" )
		str = str.gsub(/&gt;/, ">" )
		str = str.gsub(/&#8211;/, '-')
		str = str.gsub(/&#8212;/, '--')
		str = str.gsub(/&#8216;/, "'")
		str = str.gsub(/&#8217;/, "'")
		str = str.gsub(/<br \/>/, "\n")
		str = str.gsub(/&#8220;/, '"')
		str = str.gsub(/&#8221;/, '"')
		str = str.gsub(/&#8230;/, '...')
  end
  
  def stripslashes(str)
		str = str.gsub(/\//, '')
  end
end