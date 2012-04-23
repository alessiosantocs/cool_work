class CommentController < ApplicationController
  skip_before_filter :site_data
	before_filter :login_required
	before_filter :objs_required, :only => [:new]
	before_filter :super_admin_required, :except => [:new]
	
  def new
    if request.post?
      comment = params[:comment]
      new_comment = Comment.new({ :commentable_id => @obj_id, :commentable_type => @obj_type, :user_id => session[:user][:id], :title => comment[:title], :comment => comment[:comment], :parent_id => comment[:parent_id] })
      if new_comment.save
        unless params[:last_comment_id].nil?
          @comments = @obj_rec.comments.since(params[:last_comment_id].to_i) 
        else
          @comments = @obj_rec.comments(:order => "comments.id desc")
        end
        ajax_response("<%= show_comments(@comments) %>", true)
      else
        ajax_response new_comment.errors.full_messages().join(', ')
      end
    else
      ajax_response "No Go!"
    end
  end
  
  def show
    @comment = Comment.find params[:id]
    respond_to do |wants|
      wants.js{ render :inline => @comment.to_json }
    end
  end
  
  def show_image_set_for_comment
    c = Comment.find params[:id] rescue nil
    unless c.nil?
      @img_set = Comment.find_commentable(c.commentable_type, c.commentable_id)
      @img_set.image #load image
      @img_set.comments.each{ |c| c.flags } #load comments and their flags
      respond_to do |wants|
        wants.js{ render :inline => @img_set.to_json }
      end
    else
      ajax_response params[:id]
    end
  end
  
  def update
    if request.post?
      comment = Comment.find params[:comment][:id]
      if params[:delete][:true].to_i == 0
  			if comment.update_attributes(params[:comment])
  			  if params[:ignore][:true].to_i == 1
  			    f=Flag.find params[:flag][:id]
  			    f.destroy
  			  end
  			  ajax_response "Comment Updated", true
  			else
  				ajax_response "Comment Not Updated. #{comment.errors.full_messages.join('. ')}"
  			end
  		else
  		  comment.destroy 
  		  ajax_response "Comment Deleted!", true
  		end
		end		
  end
  
  def destroy
    c = Comment.find params[:id] rescue nil
    c.destroy unless c.nil?
    ajax_response params[:id], true
  end
end
