#Set Constants
if ENV['RAILS_ENV'] == 'production'
  SITE = Site.find_by_url('alltheparties.com')
else
  SITE = Site.find_by_url('fcgmedia.local')
end
SITE_ID = SITE.id
REGIONS = SITE.regions.active
r = {}
cities = {}
SITE.regions.active.each do |t| 
  r[t.short_name.to_sym] = t.id
  cities[t.short_name.to_sym] = t.cities.map(&:id).flatten
end
REGION_HASH = r
CITY_ID_HASH = cities

CITIES = City.find(:all, :conditions => ["region_id in (?)", REGIONS.collect{|r| r.id }]).collect{ |c| {:id => c.id, :name => c.full_name, :short_name => c.short_name, :region_id => c.region_id } }
ActionController::Base.session_options[:session_domain] = ".#{SITE.url}"