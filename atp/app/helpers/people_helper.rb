module PeopleHelper
  def thumbnail(user)
    if user.image_sets.empty? 
      image_tag "na120x120.jpg"
    else
      show_pictures(user.image_sets.first)
    end
  end
  
  def comments(user)
    txt = user.comments.collect{ |comment| show_comment(comment)}
    txt.empty? ? "NO COMMENTS YET" : txt.join("\n")
  end
  
  def testimonials(user)
    txt = user.testimonials.collect{ |comment| show_comment(comment)}
    txt.empty? ? "NO TESTIMONIALS YET" : txt.join("\n")
  end
  
  def faves(user,type)
    rec = Fave.find_by_user_and_type(user.id, type)
    txt = rec.collect do |r|
      content_tag("li", link_to(r[:title], redirect_path(:action => 'l', :obj_type => r[:section], :obj_id => r[:obj_id])) )
    end
    txt.empty? ? "No fave #{type.downcase} yet." : content_tag("ul", txt.to_s)
  end
  
  def friends(user)
    txt = Friend.get_friends(user.id).collect{ |f| content_tag("li", "#{image_tag "na16x16.jpg"} #{  people_link(f, true)}") }
    txt.empty? ? "No friends yet." : content_tag("ul", txt)
  end
  
  def phrases(user, type)
    txt = "No #{type} yet."
  end
end
