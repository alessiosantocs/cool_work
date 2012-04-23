class ImageSetObserver <ActiveRecord::Observer
  def after_create(record)
    case record.obj_type
    when "Event"
      username = record.image.user.username
    else
      return false
    end
    Audit.log(record, username, 'image_set', 'new image added to set')
  end
end