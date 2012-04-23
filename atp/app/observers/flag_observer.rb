class FlagObserver <ActiveRecord::Observer
  observe Flag
  
  def after_create(record)
    Audit.log(record, record.user.username, 'flag', "#{record.obj_type} marked as #{record.status}")
  end
end