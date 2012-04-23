class Admin::AccountsController < ApplicationController
  require_role "accounts"
  
  def index
    !params[:page] ? params[:page] = 1 : params[:page] = params[:page]
    if params[:a_search]
      @accounts = User.search(params[:a_search]).paginate :page => params[:page], :per_page => 10
      @item = CustomerItem.lookup(params[:a_search])
    else
      @accounts = User.paginate(:all, :conditions => 'account_id IS NOT NULL AND account_type = "customer"', :page => params[:page], :per_page => 10)
    end
  end
  
  def show
    self.current_user = User.find(params[:id])
    if logged_in?
      if !params[:redirect].blank?
        redirect_to params[:redirect]
        flash[:notice] = "Logged in via Admin panel as " + self.current_user.name
      elsif self.current_user.employee?
        redirect_back_or_default("/admin")
        flash[:notice] = "Logged in via Admin panel as " + self.current_user.name + " (Admin)"
      else
        redirect_to(dashboard_customer_path(self.current_user.account))
        flash[:notice] = "Logged in via Admin panel as " + self.current_user.name
      end
    end
  end
  
end
