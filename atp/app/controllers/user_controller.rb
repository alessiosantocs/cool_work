class UserController < ApplicationController
	before_filter :login_required, :except => [:show]
	
  def initialize
    @page_title = String.new
    @breadcrumb = Breadcrumb.new
    @menu_section = 'people'
  end
  
  def login
    redirect_to account_login_path
  end
end