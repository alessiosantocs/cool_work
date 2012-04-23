module ImageHelper
  def show_img(i, type="tiny")
    case i.class.to_s
      when "Flyer", "Ad"
        i = i.image
    end
    unless i.nil?
      return image_tag(i.link(type), {:alt=> i.caption || '', :class=> "img_#{type}", :id=>"img_#{i.id}"})
    end
    img_na(type)
  end
  
  def show_original_image(i)
    image_tag(i.link, {:alt=> i.caption || '', :class=> "img", :id=>"img_#{i.id}"})
  end
end