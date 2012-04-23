class FaveObserver <ActiveRecord::Observer
  def after_create(record)
    txt = ''
    case record.obj_type
      when 'Venue'
        txt = record.obj.name
      when 'Party'
        txt = record.obj.title
      when 'ImageSet'
        txt = 'Image'
    end
    Audit.log(record, record.user.username, 'fave', "New #{record.obj_type}: #{txt}")
  end
end