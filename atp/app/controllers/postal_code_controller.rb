class PostalCodeController < ApplicationController
	session :off
	def find
		if params[:postal_code].to_s.length==5
			postal_code=params[:postal_code].to_s
			result=PostalCode.find_zipinfo(postal_code)
			unless result.nil?
				render :inline=>"zFlag=true; city='#{result.CityName}';state='#{result.StateAbbr}';"
			else
				render :inline=>"zFlag=false;"
			end
		else
			render :inline=>"zFlag=false;"
		end
	end
end