class PartyObserver < ActiveRecord::Observer
  def before_save(record)
    if record.recur == 'multiple'
      record.tf             = 1
      record.timeframecount = 1
    end
  end

  def after_create(record)
    Audit.log(record, record.user.username, 'new', "New Party: #{record.title} at #{record.venue.name} (#{record.venue.city}, #{record.venue.state})")
  end

  def after_update(record)
    Audit.log(record, record.user.username, 'party', "Updated Party: #{record.title} at #{record.venue.name} (#{record.venue.city}, #{record.venue.state})")
  end
end