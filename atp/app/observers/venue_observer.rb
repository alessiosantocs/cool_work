class VenueObserver <ActiveRecord::Observer
  def after_create(record)
    Audit.log(record, record.user.username, 'new', "New Venue: #{record.name} (#{record.city}, #{record.state})")
  end
end