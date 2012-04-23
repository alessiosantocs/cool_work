#---
# Excerpted from "Advanced Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_arr for more book information.
#---
class FourOhFour < ActiveRecord::Base
  
  def self.add_request(host, path, referer)
    request = find_or_initialize_by_host_and_path_and_referer(host, path, referer)
    request.count += 1
    request.save
  end

end