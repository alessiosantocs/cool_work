class RatingObserver < ActiveRecord::Observer
  def after_create(record)
    Audit.log(record, record.user.username, 'rate', "#{record.rateable_type} gets a #{record.rating}")
  end
end