module ImageSetHelper
  def show_pictures(set, size='small')
    return nil if set.empty?
    items = []
    set.each do |img|
      items << content_tag("li", link_to( image_tag(img.image.link(size), {:alt=> img.image.caption || ''}), image_set_path(:id => img.id, :obj_id => img.obj_id, :obj_type => img.obj_type.downcase )), {:id=> "image_#{img.id}"})
    end
    items
  end
  
  def event_image(imgset, opt={})
    options = {
      :size => 'small'
    }.merge(opt)
    return img_na(options[:size]) unless imgset.class.to_s == "ImageSet"
    options = {
      :id => "image_set_" + imgset.id.to_s
    }.merge(options)
    i = imgset.image
    link_to(image_tag(i.link(options[:size]), {:alt=> i.caption || 'untitled' }) + (options[:size] == 'tiny' ? '' : "<span></span>"), image_single_url(:host => get_city_short_name(imgset.obj.venue.city_id) + ".#{SITE.url}", :obj_type => imgset.obj_type.to_s.downcase, :obj_id => imgset.obj_id, :id => imgset.id), { :id => options[:id]})
  end
  
  def show_other_regional_pictures(excluded_region_id=nil, pic_count=3)
    all_events=[]
    items = REGION_HASH.reject{|key, value| value == excluded_region_id}.map do |key, value|
      content_tag("span", content_tag("a", "#{key}", {:href=> "http://#{key}.#{SITE.url}/pictures" }) )
    end
    content_tag("p", "View pics from other areas: #{items.uniq.join('&nbsp;|&nbsp;')}")
  end
end