#---
# Excerpted from "Advanced Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_arr for more book information.
#---
class FourOhFoursController < ApplicationController

  def index
    FourOhFour.add_request(request.host, 
                           request.path, 
                           request.env['HTTP_REFERER'] || '')
        
    respond_to do |format|
      format.html { render :file => "#{RAILS_ROOT}/public/404.html", 
                           :status => "404 Not Found" }
      format.all  { render :nothing => true, 
                           :status => "404 Not Found" }
    end
    
  end
  
end