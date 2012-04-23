class NotesController < ApplicationController
  before_filter :login_required
  ssl_allowed :new,:edit, :create, :update, :destroy
  
  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new
    @note.order_id = params[:o_id]
    @note.customer_id = params[:c_id]
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
      format.js   { render :action => "new.html.erb", :layout => false }
    end
  end
  
  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
    
    respond_to do |format|
      format.html # new.html.erb
      format.js   { render :action => "edit.html.erb", :layout => false }
    end
  end
  
  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])
    if @note.customer_id.blank?
        @note.customer = current_user.customer
    end
    
    respond_to do |format|
      if @note.save
        Notifier.deliver_new_complaint('order@myfreshshirt.com', @note) 
        flash[:notice] = 'note was successfully created.'
#        if @note.note_type == 'Complaint'
#          users = User.administrators
#          user_mails = Array.new
#          for user in users
#            user_mails << user.email.to_s if !user.email.blank?
#          end 
#          Notifier.deliver_new_complaint('order@myfreshshirt.com', @note) 
#        end
        format.html { redirect_to :back }
        format.xml  { render :xml => @note, :status => :created, :location => @note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])
    
    respond_to do |format|
      if @note.update_attributes(params[:note])
        flash[:notice] = 'Note was successfully updated.'
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    
    respond_to do |format|
      format.html { format.html { redirect_to :back } }
      format.xml  { head :ok }
    end
  end
end
