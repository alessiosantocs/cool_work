class Admin::CustomersController < ApplicationController
  ssl_required :show
  before_filter :employee_required, :only => [:show]
  require_role "accounts", :only => [:show]
  
  def show
    @customer = Customer.find(params[:id])
    @customer_preferences = @customer.preferences
    @user = @customer.user
    @address = @customer.addresses[0]
    @building = @address.building
  end
end
