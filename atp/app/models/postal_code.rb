class PostalCode < ActiveRecord::Base
	def self.find_zipinfo(zip)
	  find(:first, { :conditions => ["ZIPCode=? and CityType='D'", zip.to_s] })
	end
	
	def long
		self.Longitude
	end
	
	def lat
		self.Latitude
	end
	
	def tz
		self.UTC += 1 if self.DST == 'Y'
		zone = {"-4.0"=>"Eastern Time (US & Canada)", 
					"-5.0"=>"Indiana (East)", 
					"-6.0"=>"Central Time (US & Canada)",
					"-7.0"=>"Mountain Time (US & Canada)",
					"-8.0"=>"Pacific Time (US & Canada)", 
					"-9.0"=>"Alaska", 
					"-10.0"=>"Hawaii", 
					"-11.0"=>"Midway Island", 
					"-12.0"=>"International Date Line West" }
		return zone[self.UTC.to_s]
	end
end