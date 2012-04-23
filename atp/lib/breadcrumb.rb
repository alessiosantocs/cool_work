module Breadcrumb
	class Breadcrumb
		def initialize
			@home = {:title => 'Home', :url => '/'} #http://www.stylemodo.com
			@trail = Array.new
		end
		
		def drop_crumb(title, url = nil) 
			@trail << {:title => title.to_s, :url => url} unless title.nil?
		end
		
		def print_trail(separator='&raquo;')
			output = String.new
			if @trail.size > 0
				output << '<a href="' + @home[:url] + '">' + @home[:title] + '</a>'
				for crumb in @trail
					x = (!crumb[:url].nil?) ? '<a href="' + crumb[:url] + '">' + crumb[:title] + '</a>' : crumb[:title]
					output << ' ' + separator + ' ' + x
				end
			end
			output
		end
	end
end