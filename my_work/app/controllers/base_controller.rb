# Unlike the other BaseControllers, this is just here
# to serve as the website homepage/root.

class BaseController < ApplicationController
  
  ssl_allowed :index
  
  def index
  end
end
