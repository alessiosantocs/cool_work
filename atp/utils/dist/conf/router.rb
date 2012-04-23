# Merb::RouteMatcher is the request routing mapper for the merb framework.
# You can define placeholder parts of the url with the :smbol notation.
# so r.add '/utils/foo/:bar/baz/:id', :class => 'Bar', :method => 'foo'
# will match against a request to /foo/123/baz/456. It will then
# use the class Bar as your merb controller and call the foo method on it. 
# the foo method will recieve a hash with {:bar => '123', :id => '456'}
# as the content. So the :placeholders sections of your routes become
# a hash of arguments to your controller methods.
# The default route is installed 

puts "Compiling routes: \n"
Merb::RouteMatcher.prepare do |r|
  r.add '/utils/flyer/:action', :controller => "flyer_controller"
  r.add '/utils/audit/:action', :controller => "audit_controller"
  r.add '/utils/image/:action/:id', :controller => "image_controller"
  r.add '/utils/msg/:action/:id', :controller => "msg_controller"
  r.add '/utils/test', :controller => "search", :action => "test"
  r.add '/utils/l', :controller => "audit_controller", :action => "log"
  r.add '/utils/:controller/:action'
  r.add '/utils/:controller/:action/:id'
  r.add '/utils/', :controller => "search", :action => "index"
end

m = Merb::RouteMatcher.new
puts m.compiled_statement