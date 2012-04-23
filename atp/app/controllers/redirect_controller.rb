class RedirectController < ApplicationController
  session :off
  skip_before_filter :site_data
	before_filter :objs_required
	
  def local
    case @obj_type
      when 'Comment'
        handle_comment(@obj_rec)
      when 'Fave', 'Flag'
        handle_object(@obj_rec)
      when 'ImageSet','Party', 'Venue'
        goto_object(@obj_rec)
      when 'Rating'
        handle_rating(@obj_rec)
      when 'Vote'
        handle_vote(@obj_rec)
      else
        flash[:bad] = "That link no longer exists"
        redirect_to home_url
        return
    end
  end
  alias :l :local
  
  private
  def goto_object(obj, anchor=nil)
    case obj.class.to_s
      when 'ImageSet'
        redirect_to image_single_url(:id=> obj.id, :obj_type => obj.obj_type, :obj_id => obj.obj_id, :anchor => anchor)
      when 'Party'
        redirect_to party_url(:subdomain => obj.venue.city.region.short_name, :id=> obj.id, :anchor => anchor)
      when 'Venue'
        redirect_to venue_url(:id=> obj.id, :anchor => anchor)
    end
    return false
  end
  
  def handle_comment(obj)
    case obj.commentable_type
      when 'ImageSet'
        goto_object(obj.commentable, "comment_"+obj.id.to_s)
    end
  end
  
  def handle_object(obj)
    case obj.obj_type
      when 'Comment'
        handle_comment(obj.obj)
      when 'ImageSet','Party', 'Venue'
        goto_object(obj.obj)
    end
  end
  
  def handle_rating(obj)
    case obj.rateable_type
      when 'Image'
        obj = ImageSet.find(:first, :conditions => ["image_id=?", obj.rateable_id])
        goto_object(obj)
    end
  end
  
  def handle_vote(obj)
    case obj.voteable_type
      when 'Comment'
        handle_comment(obj.voteable)
    end
  end
end