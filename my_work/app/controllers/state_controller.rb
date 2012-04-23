class StateController < ApplicationController
  before_filter :admin_required
  def new
    @state = State.new
    render :layout => false 
  end

  def edit
    @state = State.find(params[:id])  
    respond_to do |format|
      format.html # new.html.erb
      format.js   { render :action => "edit.html.erb", :layout => false }
    end
  end
  
  def create
    @state = State.new(params[:state])
    if @state.save
        flash[:notice] = 'State was successfully created.'
        redirect_to :back
     else
        flash[:notice] = 'State was not created.'
        redirect_to :back
      end
  end
  
  def update
    @state = State.find(params[:id])
    if @state.update_attributes(params[:state])
      flash[:notice] = 'State was successfully updated.'
      redirect_to :back
    else
      flash[:notice] = 'State was not updated.'
      redirect_to :back
    end
  end  
    
end
