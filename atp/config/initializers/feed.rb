require 'feed'
include Feed
FEED_YAML_PATH = "#{RAILS_ROOT}/config/feed.yml"
FEED_URL, FEED_XML, FEED_TTL = SETTING["blog"]["url"], SETTING["blog"]["xml"], SETTING["blog"]["ttl"]