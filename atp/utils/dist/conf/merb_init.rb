puts "merb init called"
# add your own ruby code here for app initialization and load path stuff
SETTING = YAML::load(File.open(DIST_ROOT+"/../../config/settings.yml"))
require 'active_record'
ActiveRecord::Base.logger = MERB_LOGGER
ActiveRecord::Base.establish_connection(
  :adapter => 'mysql',
  :username => 'root',
  :password => '',
  :database => 'atp_dev'
)

ActiveRecord::Base.verification_timeout = 14400

Dir[DIST_ROOT+"/lib/**/*.rb"].each { |m| require m }
Dir[DIST_ROOT+"/app/controllers/*.rb"].sort.each { |m| require m }
Dir[DIST_ROOT+"/app/models/*.rb"].each { |m| require m }
Dir[DIST_ROOT+"/app/helpers/*.rb"].each { |m| require m }
Dir[DIST_ROOT+"/plugins/*/init.rb"].each { |m| require m }

module Merb
  PER_PAGE = 10
end

ActiveRecord::Base.class_eval do
  def dom_id(prefix=nil)
    display_id = new_record? ? "new" : id
    prefix = prefix.nil? ? self.class.name.underscore : "#{prefix}_#{self.class.name.underscore}"
    "#{prefix}_#{display_id}"
  end
end

module Merb
  class ViewContext
    include Merb::GlobalHelper
  end
end

