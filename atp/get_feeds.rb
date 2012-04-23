if File.directory? '/data/frstclan/current'
  BASE_PATH = "/data/frstclan/current"
  ENV['RAILS_ENV'] = 'production'
elsif File.directory? "/Users/onyekwelu/workspace/atp/trunk"
  BASE_PATH = "/Users/onyekwelu/workspace/atp/trunk"
  ENV['RAILS_ENV'] = 'development'
else
  puts "look at current directories listed here and make changes"
  exit
end

require 'rubygems'
require 'feed-normalizer'
require 'yaml'
SETTING = YAML::load(File.open("#{BASE_PATH}/config/settings.yml"))

@urls = SETTING["blog_rss_url"]
@urls.each do |url|
  feed = FeedNormalizer::FeedNormalizer.parse open url
  puts url
  puts "items: #{ feed.items }"
end

