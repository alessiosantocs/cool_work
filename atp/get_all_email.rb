if File.directory? '/data/frstclan/current'
  ROOT = "/data/frstclan/current"
  ENV['RAILS_ENV'] = 'production'
elsif File.directory? "/Users/onyekwelu/workspace/atp/trunk"
  ROOT = "/Users/onyekwelu/workspace/atp/trunk"
  ENV['RAILS_ENV'] = 'development'
else
  puts "look at current directories listed here and make changes"
  exit
end

require 'fileutils'
require 'config/boot'
require 'config/environment'

def get_list(time, o,l, growth)
  u = User.get_mailing_list_since(time, o, l)
  puts u.join("\n")
  if u.size > 0
    get_list(time, o + growth, l, growth)
  end
end

offset = 0
limit = 50
growth = 50
start = 6.months.ago #6.years.ago.utc
get_list(start, offset, limit, growth)

