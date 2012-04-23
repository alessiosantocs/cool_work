class Admin::EmployeesController < ApplicationController
  require_role "admin"
  
  def index
    params[:sort] ? sort = params[:sort] : sort = 'created_at'
    if params[:orderby] && !params[:orderby].empty?
      sort = sort + " #{params[:orderby]}"
      params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
    else
      sort = sort + " desc"
      @orderby = 'asc'
    end
    @employees = Employee.find(:all).paginate :page => params[:page], :per_page => 10
  end
  
  # render new.rhtml
  def new
    @employee = Employee.new
    @user = User.new
    @building = Building.new
    @address = Address.new
  end
  
  def create
    @employee = Employee.new(params[:employee])
    @user = @employee.build_user(params[:user])
    @employee.user.user_class = "employee"
    @building = Building.find_or_initialize(params[:building])
    @address = @employee.addresses.build(params[:address])
    @address.building = @building
    
    params['user_roles'].keys.each do |name| 
      if params['user_roles'][name] == 'true'
        @user.roles << Role.role(name) if !@user.has_role?(name)
      else
        @user.roles.delete(Role.role(name))
      end
    end
    
    if @employee.save
      redirect_to admin_employees_path
      flash[:notice] = "Employee successfully created"
    else
      render :action => 'new'
    end
  end
  
  
  def edit
    @employee = Employee.find(params[:id])
    @user = @employee.user 
    @address = @employee.addresses[0]
    @building = @address.building
  end
  
  def update
    @employee = Employee.find(params[:id])
    @user = @employee.user 
    @address = @employee.addresses[0]
    @building = @address.building
    $user_email = @user.email
    $current_password = @user.password
    params['user_roles'].keys.each do |name| 
      if params['user_roles'][name] == 'true'
        @user.roles << Role.role(name) if !@user.has_role?(name)
      else
        @user.roles.delete(Role.role(name))
      end
    end

    if (@employee.update_attributes(params[:employee]) && @user.update_attributes(params[:user]) && @address.update_attributes(params[:address]) && @building.update_attributes(params[:building]))
      redirect_to admin_employees_path
      flash[:notice] = "Employee successfully edited"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.user.destroy
    @employee.destroy
    redirect_to admin_employees_path
  end
end
