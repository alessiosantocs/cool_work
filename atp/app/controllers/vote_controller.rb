class VoteController < ApplicationController
  skip_before_filter :site_data
	before_filter :login_required
	before_filter :objs_required
	
  def tally
    vote = params[:vote].to_i
    new_vote = Vote.new( { :voteable_id => @obj_id, :voteable_type => @obj_type, :user_id => session[:user][:id], :vote => vote } )
    if new_vote.save
      ajax_response "<%= show_vote(@obj_rec) %>", true
    else
      ajax_response new_vote.errors.full_messages().join(', ')
    end
  end
end