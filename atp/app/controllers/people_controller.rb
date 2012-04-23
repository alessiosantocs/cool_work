class PeopleController < ApplicationController
  helper :image_set
  before_filter :login_required

  def initialize
  	super
  	@menu_section = "people"
  end
  
  def show
    if @user = User.find_by_username(params[:username])
      @page_title << "People :: " + @user.username
      add2ads "120x600_ros"
      add2ads "336x280_ros"
      add2ads "120x120_people"
    else
      flash[:bad] = "No such user by the name of #{params[:username]}"
      redirect_to "/"
    end
  end
  
  def update
    @user = User.find(session[:user][:id])
  end
end
